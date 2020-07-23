tab=$(printf '\t')

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
        public_ip: .PublicIpAddress,
        private_ip: .PrivateIpAddress,
        launch_time: .LaunchTime
    }
EOF
    aws ec2 describe-instances \
        --query 'Reservations[*].Instances[*]' \
        --filters 'Name=instance-state-name,Values=running' | jq "$jq_query"
}

function aws-ec2-instance-ls() {
    {
        echo -e "Name\tID\tPublic IP\tPrivate IP\tAvailability Zone\tLaunch Time"
        aws-ec2-instance-describe-short | jq -r '[.name, .instance_id, .public_ip, .private_ip, .availability_zone, .launch_time] | join("\t")'
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

    local instances=$(aws-asg-get-instances "$asg_name")
    while read i; do
        local ip=$(aws-ec2-instance-public-ip "$i")

        ssh -n -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$ip" "$action"
    done <<<"$instances"
}

function _aws-lt-ls() {
    aws ec2 describe-launch-templates | jq -r '.LaunchTemplates[] | [.LaunchTemplateName, .LaunchTemplateId, .LatestVersionNumber] | join("\t")'
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

function aws-ssh() {
    local instance=$(aws-ec2-instance-select)
    local instance_ip=$(echo "$instance" | awk -F"$tab" '{ print $3 }')
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$@" "$instance_ip"
}

function aws-ssm-parameter-ls() {
    aws ssm describe-parameters --query 'Parameters[].Name' --output text | aws-canonicalize-text | sort
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
    aws ssm describe-parameters |
        jq -r '.Parameters[] | (.Name + "\t" + .Description)' |
        aws-columnize | fzf | awk '{ print $1 }'
}
