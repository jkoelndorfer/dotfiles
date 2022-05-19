tab=$(printf '\t')

_aws_version_output=$(aws --version 2>&1 | grep -E '^aws-cli/')
if [[ "$_aws_version_output" =~ '^\s*aws-cli/([0-9]+)\.' ]]; then
    AWS_CLI_VERSION=${match[1]}
else
    AWS_CLI_VERSION='?'
fi
unset _aws_version_output

function aws() {
    if [[ "$AWS_CLI_VERSION" == '2' ]]; then
        command aws --no-cli-pager "$@"
    else
        command aws "$@"
    fi
}

function aws-canonicalize-text() {
    sed -e 's/\t/\n/g'
}

function aws-columnize() {
    column -t -s "$tab" -o "$tab"
}

function aws-ec2-instance-describe-short() {
    local jq_query
    read -rd '' jq_query <<'EOF'
    .[][] | {
        name: ((.Tags[] | select(.Key == "Name") | .Value) // "unnamed"),
        availability_zone: .Placement.AvailabilityZone,
        instance_id: .InstanceId,
        image_id: .ImageId,
        instance_type: .InstanceType,
        public_ip: .PublicIpAddress,
        private_ip: .PrivateIpAddress,
        launch_time: .LaunchTime,
        lifecycle: (.InstanceLifecycle // "normal")
    }
EOF
    aws ec2 describe-instances \
        --max-items 9999 \
        --query 'Reservations[*].Instances[*]' \
        --filters 'Name=instance-state-name,Values=running' | jq "$jq_query"
}

function aws-ec2-instance-ls() {
    {
        echo -e "Name\tID\tType\tImage ID\tLifecycle\tPublic IP\tPrivate IP\tAvailability Zone\tLaunch Time"
        aws-ec2-instance-describe-short | jq -r '[.name, .instance_id, .instance_type, .image_id, .lifecycle, .public_ip, .private_ip, .availability_zone, .launch_time] | join("\t")'
    } | aws-columnize
}

# Dumps out all of the EC2 instances with the given name.
function aws-ec2-instances-named() {
    local name="$1"
    aws ec2 describe-instances --filters "Name=tag:Name,Values=$name"
}

function aws-ec2-instance-names() {
    aws ec2 describe-instances --query 'Reservations[*].Instances[*].Tags[?Key==`Name`].Value' | jq -r '.[][0][0]' | sort -u
}

function aws-ec2-instance-select() {
    aws-ec2-instance-ls | fzf --header-lines 1
}

function aws-ec2-instance-terminate() {
    local selected_instance=$(aws-ec2-instance-select)
    [[ -n "$selected_instance" ]] || return 1
    local instance_name=$(echo "$selected_instance" | awk -F"$tab" '{ print $1 }' | trim-string)
    local instance_id=$(echo "$selected_instance" | awk -F"$tab" '{ print $2 }' | trim-string)

    confirm-cmd "terminate instance $instance_name ($instance_id)" aws ec2 terminate-instances --instance-ids "$instance_id"
}

function aws-ec2-instance-public-ip() {
    local instance_id=$1

    aws ec2 describe-instances \
        --instance-id "$instance_id" \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text
}

function aws-ec2-security-group-ls() {
    {
        echo -e "Group Name\tGroup ID\tVPC ID"
        aws ec2 describe-security-groups | jq -r '.SecurityGroups[] | [.GroupName, .GroupId, .VpcId] | join("\t")' | sort
    } | aws-columnize
}

function aws-ec2-security-group-select() {
    aws-ec2-security-group-ls | fzf --header-lines 1
}

function aws-ec2-security-group-select-id() {
    aws-ec2-security-group-select | awk -F"$tab" '{ print $2 }'
}

function aws-ec2-security-group-delete() {
    local security_group_defn=$(aws-ec2-security-group-select)
    [[ -n "$security_group_defn" ]] || return 1
    security_group_name=$(echo "$security_group_defn" | awk -F"$tab" '{ print $1 }' | trim-string)
    security_group_id=$(echo "$security_group_defn" | awk -F"$tab" '{ print $2 }' | trim-string)
    confirm-cmd "delete security group $security_group_name ($security_group_id)" aws ec2 delete-security-group --group-id "$security_group_id"
}

function _aws-ami-ls() {
    aws ec2 describe-images --owners self | jq -r '.Images[] | [.Name, .ImageId, .CreationDate] | join("\t")' | sort -k3 -r -t "$tab"
}

function aws-ami-ls() {
    _aws-ami-ls | aws-columnize
}

function aws-ami-select() {
    {
        echo -e "Name\tImage ID\tCreation Date"
        _aws-ami-ls
    } | aws-columnize | fzf --header-lines 1 | awk -F"$tab" '{ print $2 }'
}

function aws-ami-snapshot-ls() {
    local image_id=$1
    if [[ -z "$image_id" ]]; then
        echo "$0: image ID must be specified" >&2
        return 1
    fi
    aws ec2 describe-images \
        --image-ids "$image_id" \
        --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId' \
        --output text | aws-canonicalize-text
}

function aws-ami-rm() {
    local image_id=$1
    local image_snapshots=($(aws-ami-snapshot-ls "$image_id"))
    if [[ -z "$image_snapshots" ]]; then
        echo "$0: Could not determine snapshots for AMI ID $image_id; is the ID correct?" >&2
        return 1
    fi
    aws ec2 deregister-image --image-id "$image_id"
    for s in "${image_snapshots[@]}"; do
        aws ec2 delete-snapshot --snapshot-id "$s"
    done
}

function aws-asg-ls() {
    aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].AutoScalingGroupName' --output text |
        aws-canonicalize-text | sort
}

function aws-asg-set-min() {
    local asg_name=$1
    local min_size=$2

    aws autoscaling update-auto-scaling-group --auto-scaling-group-name "$asg_name" --min-size "$min_size"
}

function aws-asg-set-desired() {
    local asg_name=$1
    local desired_capacity=$2

    aws autoscaling update-auto-scaling-group --auto-scaling-group-name "$asg_name" --desired-capacity "$desired_capacity"
}

function aws-asg-set-max() {
    local asg_name=$1
    local max_size=$2

    aws autoscaling update-auto-scaling-group --auto-scaling-group-name "$asg_name" --max-size "$max_size"
}

function aws-asg-get-instances() {
    local asg_name=$1

    aws autoscaling describe-auto-scaling-groups \
        --auto-scaling-group-name "$asg_name" \
        --query 'AutoScalingGroups[0].Instances[*].InstanceId' \
        --output text | aws-canonicalize-text
}

function aws-asg-ssh-each() {
    local asg_name=$1
    local action=$2

    local instance_ids=$(aws-asg-get-instances "$asg_name" | sort)
    local instance_defns=$(aws-ec2-instance-ls | sort -k2)
    local output_fmt=$(for i in $(seq 1 10); do printf "2.%d " i; done | sed -r -e 's#\s*$##')
    local joined_instance_defns=$(join -1 1 -2 2 <(<<<"$instance_ids") <(<<<"$instance_defns") -o "$output_fmt" | sed -r -e 's#\s+#\t#g')
    while read i; do
        local ip=$(_aws-instance-ip "$i")

        _aws-ssh -n "$ip" "$action"
    done <<<"$joined_instance_defns"
}

function _aws-instance-ip() {
    local instance_defn=$1
    local mode
    if [[ "$AWS_SSH_MODE" == 'public' ]]; then
        mode='public'
    else
        if [[ "$AWS_PROFILE" == 'aerisweather' ]]; then
            mode='private'
        else
            mode='public'
        fi
    fi

    local field
    if [[ "$mode" == 'public' ]]; then
        field=6
    else
        field=7
    fi

    echo "$instance_defn" | awk -F"$tab" "{ print \$$field }" | trim-string
}

function _aws-lt-ls() {
    aws ec2 describe-launch-templates | jq -r '.LaunchTemplates[] | [.LaunchTemplateName, .LaunchTemplateId, .LatestVersionNumber] | join("\t")'
}

function _aws-ssh() {
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$@"
}

function aws-lt-ls() {
    {
        echo -e 'Launch Template Name\tLaunch Template ID\tLatest Version'
        _aws-lt-ls
    } | aws-columnize
}

function aws-lt-select() {
    aws-lt-ls | fzf --header-lines 1 | awk -F"$tab" '{ print $2 }'
}

function aws-lt-set-ami() {
    local lt_name=$1
    local ami_id=$2

    aws ec2 create-launch-template-version --launch-template-name "$lt_name" --source-version '$Latest' --launch-template-data '{"ImageId": "'"$ami_id"'"}'
}

function aws-s3-get() {
    local object_path=$1

    if [[ -z "$object_path" ]]; then
        echo "$0: must specify path to S3 object, e.g s3://bucket/path/to/object" >&2
        return 1
    fi
    aws s3 cp --quiet "$object_path" /dev/stdout
}

function aws-ssh() {
    local instance=$(aws-ec2-instance-select)
    if [[ -z "$instance" ]]; then
        return 1
    fi
    local instance_ip=$(_aws-instance-ip "$instance")
    _aws-ssh "$@" "$instance_ip"
}

function aws-ssm-parameter-ls() {
    aws ssm describe-parameters --page-size 50 --query 'Parameters[].Name' --output text | aws-canonicalize-text | sort
}
alias ls-ssmp=aws-ssm-parameter-ls

function aws-ssm-parameter() {
    if [[ -n "$1" ]]; then
        local name=$1
    else
        local name=$(aws-ssm-parameter-select)
    fi
    aws ssm get-parameter --name "$name" --with-decryption | jq -r '.Parameter.Value'
}
alias ssmp=aws-ssm-parameter

function aws-ssm-parameter-select() {
    aws ssm describe-parameters --page-size 50 |
        jq -r '.Parameters[] | (.Name + "\t" + .Description)' |
        aws-columnize | fzf | awk '{ print $1 }'
}

function aws-ssm-parameter-get() {
    if [[ -n "$1" ]]; then
        local parameter=$1
    else
        local parameter=$(aws-ssm-parameter-select)
    fi

    local get_result=$(aws ssm get-parameter --name "$parameter" --query 'Parameter' --with-decryption 2>/dev/null)
    if [[ -z "$get_result" ]]; then
        echo "failed getting parameter $parameter (does it exist?)" >&2
        return 1
    fi

    local description=$(aws ssm describe-parameters --page-size 50 --parameter-filters "Key=Name,Values=$parameter" --query 'Parameters[].Description' --output text)
    echo -E "$get_result" | jq -M -r --arg description "$description" '{Name: .Name, Type: .Type, Description: $description, Value: .Value}'
}

function aws-ssm-parameter-edit() {
    if [[ -n "$1" ]]; then
        local parameter=$1
    else
        local parameter=$(aws-ssm-parameter-select)
    fi
    local tempfile=$(mktemp --tmpdir 'aws-ssm-edit-parameter.XXXXXX')
    if [[ -z "$tempfile" ]]; then
        echo 'failed to create temporary file to edit SSM parameter' >&2
        return 1
    fi

    local parameter_get="$(aws-ssm-parameter-get "$parameter")"
    local rc=$?
    if [[ "$rc" != 0 ]]; then
        return "$rc"
    fi

    local parameter_values=$(echo -E "$parameter_get" | _aws-ssm-parameter-stream-edit)
    echo -E "$parameter_values" | _aws-ssm-parameter-put
    local rc=$?
    local new_parameter_name=$(echo -E "$parameter_values" | jq -r '.Name')
    if [[ "$rc" != 0 ]]; then
        echo "failed putting parameter $new_parameter_name" >&2
        return 1
    fi
    if [[ "$parameter" != "$new_parameter_name" ]]; then
        aws ssm delete-parameter --name "$parameter"
    fi
}

function aws-ssm-parameter-new() {
    local name=$1

    local parameter_new=$(
        jq \
            --null-input \
            --arg Name "$name" \
            --monochrome-output '{Name: $Name, Type: "String or SecureString", Description: "Description", Value: "value"}' |
        _aws-ssm-parameter-stream-edit
    )
    if [[ "$?" != 0 ]]; then
        echo "failed editing parameter $name" >&2
        return 1
    fi
    echo -E "$parameter_new" | _aws-ssm-parameter-put
}

function aws-ssm-parameter-new-from() {
    local src=$1
    local new=$2

    if [[ -z "$src" ]]; then
        echo 'missing source parameter name' >&2
        return 1
    fi
    if [[ -z "$new" ]]; then
        echo 'missing new parameter name' >&2
        return 1
    fi

    local parameter_get="$(aws-ssm-parameter-get "$src")"
    local rc=$?
    if [[ "$rc" != 0 ]]; then
        return "$rc"
    fi
    local parameter_new=$(
        echo -E "$parameter_get" |
        jq --arg NewName "$new" --monochrome-output '{Name: $NewName, Type: .Type, Description: .Description, Value: .Value}' |
        _aws-ssm-parameter-stream-edit
    )
    if [[ "$?" != 0 ]]; then
        echo "failed editing parameter $src" >&2
        return 1
    fi
    echo -E "$parameter_new" | _aws-ssm-parameter-put
}

function aws-ssm-parameter-mv() {
    local src=$1
    local dest=$2

    if [[ -z "$src" ]]; then
        echo 'missing source parameter name' >&2
        return 1
    fi
    if [[ -z "$dest" ]]; then
        echo 'missing destination parameter name' >&2
        return 1
    fi
    if [[ "$src" == "$dest" ]]; then
        echo 'source and destination parameters are the same' >&2
        return 1
    fi

    local param=$(aws-ssm-parameter-get "$src")
    local rc=$?
    if [[ "$rc" != 0 ]]; then
        return "$rc"
    fi

    echo -E "$param" | _aws-ssm-parameter-put "$dest"
    local rc=$?
    if [[ "$rc" != 0 ]]; then
        return "$rc"
    fi
    aws ssm delete-parameter --name "$src"
}

function aws-ssm-parameter-rm() {
    local param=$1
    aws ssm delete-parameter --name "$param"
}

function _aws-ssm-parameter-stream-edit() {
    {
        local parameter_values=$(< /dev/stdin)
        local tempfile=$(mktemp --tmpdir 'aws-ssm-parameter-stream-edit.XXXXXX')
        echo -E "$parameter_values" > "$tempfile"

        exec 7< /dev/tty
        while true; do
            "$EDITOR" "$tempfile" < /dev/tty > /dev/tty 2>&1
            local jq_validation_output
            local rc
            jq_validation_output=$(
                jq \
                    --compact-output \
                    --monochrome-output \
                    --exit-status \
                    '.Name != null and .Type != null and .Description != null and .Value != null' \
                    2>/dev/null < "$tempfile"
            )
            rc=$?
            if [[ "$rc" == 1 ]]; then
                echo 'JSON was missing one of Name, Type, Description, Value; try again?' >&2
                read -u 7
            elif [[ "$rc" == 4 ]]; then
                echo 'not valid JSON, try again?' >&2
                read -u 7
            elif [[ "$(echo "$jq_validation_output" | wc -l 2>/dev/null)" -ne 1 ]]; then
                echo 'one line of JSON expected in edit file; try again?' >&2
                read -u 7
            elif [[ "$rc" == 0 ]]; then
                break
            else
                echo 'unhandled error' >&2
                exec 7<&-
                return 1
            fi
        done
        exec 7<&-
    } > /dev/null
    cat "$tempfile"
    rm -f "$tempfile" > /dev/null
}

function _aws-ssm-parameter-put() {
    local name_override=$1
    local parameter_values=$(< /dev/stdin)
    if [[ -z "$name_override" ]]; then
        local parameter_name=$(echo -E "$parameter_values" | jq -r '.Name')
    else
        local parameter_name=$name_override
    fi
    local parameter_desc=$(echo -E "$parameter_values" | jq -r '.Description')
    local parameter_type=$(echo -E "$parameter_values" | jq -r '.Type')
    local parameter_val=$(echo -E "$parameter_values" | jq -r '.Value')

    aws ssm put-parameter \
        --name "$parameter_name" \
        --type "$parameter_type" \
        --description "$parameter_desc" \
        --value "$parameter_val" \
        --overwrite
    if [[ "$?" != 0 ]]; then
        echo "failed to put parameter $parameter_name" >&2
        return 1
    fi
}
