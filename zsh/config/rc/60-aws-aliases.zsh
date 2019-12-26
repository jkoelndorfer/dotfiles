tab=$(printf '\t')

function aws-canonicalize-text() {
    sed -e 's/\t/\n/g'
}

function aws-columnize() {
    column -t -s "$tab" -o "$tab"
}

function aws-field() {
    local field_number=$1
    awk -F "$tab" "{ print \$${field_number} }"
}

function aws-has-fields() {
    [[ "$1" =~ $tab ]]
}

function aws-select() {
    local field_number=$1
    fzf --header-lines 1 | aws-field "$field_number"
}

function aws-sort() {
    sort -t "$tab" "$@"
}

function aws-present-header() {
    while [[ -n "$1" ]]; do
        printf "$1"
        [[ -n "$2" ]] && printf "$tab"
        shift
    done
    echo
}

function aws-ec2-instance-describe-short() {
    local jq_query
    read -rd '' jq_query <<'EOF'
    .[][] | {
        name: ((.Tags[] | select(.Key == "Name") | .Value) // "unnamed"),
        availability_zone: .Placement.AvailabilityZone,
        instance_id: .InstanceId,
        public_ip: .PublicIpAddress,
        launch_time: .LaunchTime
    }
EOF
    aws ec2 describe-instances \
        --query 'Reservations[*].Instances[*]' \
        --filters 'Name=instance-state-name,Values=running' | jq "$jq_query"
}

function aws-ec2-instance-ls() {
    {
        aws-present-header 'Name' 'ID' 'Public IP' 'Availability Zone' 'Launch Time'
        aws-ec2-instance-describe-short | jq -r '[.name, .instance_id, .public_ip, .availability_zone, .launch_time] | join("\t")'
    } | aws-columnize
}

function aws-ec2-instance-select() {
    aws-ec2-instance-ls | aws-select
}

function aws-ec2-instance-select-id() {
    aws-ec2-instance-select | aws-field 2
}

function aws-ec2-instance-terminate() {
    local instance_id=$1
    local instance_name=$2
    if [[ -n "$instance_name" ]]; then
        local confirm_msg="terminate instance $instance_name ($instance_id)"
    else
        local confirm_msg="terminate instance $instance_id"
    fi
    confirm-cmd "$confirm_msg" aws ec2 terminate-instances --instance-ids "$instance_id"
}

function aws-ec2-instance-select-terminate() {
    local selected_instance=$(aws-ec2-instance-select)
    local instance_name=$(echo "$selected_instance" | aws-field 1 | trim-string)
    local instance_id=$(echo "$selected_instance" | aws-field 2 | trim-string)
    aws-ec2-instance-terminate "$instance_id" "$instance_name"
}

function aws-ec2-instance-public-ip() {
    local instance_id=$(value-or-cmd "$1" aws-ec2-instance-select-id)

    aws ec2 describe-instances \
        --instance-id "$instance_id" \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text | trim-string
}

function aws-ec2-security-group-ls() {
    {
        aws-present-header 'Group Name' 'Group ID' 'VPC ID'
        aws ec2 describe-security-groups | jq -r '.SecurityGroups[] | [.GroupName, .GroupId, .VpcId] | join("\t")' | sort
    } | aws-columnize
}

function aws-ec2-security-group-select() {
    aws-ec2-security-group-ls | aws-select
}

function aws-ec2-security-group-select-id() {
    aws-ec2-security-group-select | aws-field 2
}

function aws-ec2-security-group-delete() {
    local security_group_defn=$(value-or-cmd "$1" aws-ec2-security-group-select)
    if aws-has-fields "$security_group_defn"; then
        security_group_name=$(echo "$security_group_defn" | aws-field 1 | trim-string)
        security_group_id=$(echo "$security_group_defn" | aws-field 2 | trim-string)
        confirm_msg="delete security group $security_group_name ($security_group_id)"
    else
        security_group_id=$security_group_defn
        confirm_msg="delete security group $security_group_id"
    fi
    confirm-cmd "$confirm_msg" aws ec2 delete-security-group --group-id "$security_group_id"
}

function aws-ec2-subnet-ls() {
    local jq_query
    read -rd '' jq_query <<'EOF'
    .Subnets[] |
        [(.Tags[] | select(.Key == "Name") | .Value) // "-", .SubnetId, .CidrBlock, .VpcId, .AvailabilityZone] |
        join("\t")
EOF
    {
        aws-present-header 'Name' 'Subnet ID' 'CIDR Block' 'VPC ID' 'Availability Zone'
        aws ec2 describe-subnets | jq -r "$jq_query" | sort
    } | aws-columnize
}

function aws-ami-ls() {
    {
        aws-present-header 'Name' 'Image Id' 'Creation Date'
        aws ec2 describe-images --owners self |
            jq -r '.Images[] | [.Name, .ImageId, .CreationDate] | join("\t")' |
            aws-sort -k3 -r
    } | aws-columnize
}

function aws-ami-select() {
    aws-ami-ls | aws-select
}

function aws-ami-snapshot-ls() {
    local image_id=$(value-or-cmd "$1" aws-ami-select)
    [[ -n "$image_id" ]] || return 1
    aws ec2 describe-images \
        --image-ids "$image_id" \
        --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId' \
        --output text | aws-canonicalize-text
}

function aws-ami-rm() {
    local image_id=$(value-or-cmd "$1" aws-ami-select)
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
    local jq_query
    read -rd '' jq_query <<'EOF'
    .AutoScalingGroups[] | [
        .AutoScalingGroupName,
        (.Instances | length),
        ([.Instances[] | select(.LifecycleState == "InService")] | length),
        .MinSize,
        .DesiredCapacity,
        .MaxSize,
        (.AvailabilityZones | join(", "))
    ] | join("\t")
EOF
    {
        aws-present-header 'Autoscaling Group Name' '# Instances' '# InService' 'Min' 'Desired' 'Max' 'Availability Zones'
        aws autoscaling describe-auto-scaling-groups |
            jq -r "$jq_query" |
            aws-sort
    } | aws-columnize
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

function aws-lt-ls() {
    {
        aws-present-header 'Launch Template Name' 'Launch Template ID' 'Latest Version'
        aws ec2 describe-launch-templates |
            jq -r '.LaunchTemplates[] | [.LaunchTemplateName, .LaunchTemplateId, .LatestVersionNumber] | join("\t")'
    } | aws-columnize
}

function aws-lt-select() {
    aws-lt-ls | aws-select | aws-field 2
}

function aws-lt-set-ami() {
    local lt_name=$1
    local ami_id=$2

    aws ec2 create-launch-template-version --launch-template-name "$lt_name" --source-version '$Latest' --launch-template-data '{"ImageId": "'"$ami_id"'"}'
}

function aws-ssm-parameter-ls() {
    {
        aws-present-header 'Name' 'Description'
        aws ssm describe-parameters | jq -r '.Parameters[] | [.Name, .Description] | join("\t")'
    } | aws-columnize
}
alias ls-ssmp=aws-ssm-parameter-ls

function aws-ssm-parameter() {
    if [[ -n "$1" ]]; then
        local name=$1
    else
        local name=$(aws-ssm-parameter-select-name)
    fi
    aws ssm get-parameter --name "$name" --with-decryption | jq -r '.Parameter.Value'
}
alias ssmp=aws-ssm-parameter

function aws-ssm-parameter-select() {
    {
        aws ssm describe-parameters |
            jq -r '.Parameters[] | (.Name + "\t" + (.Description // "-"))'
    } | aws-columnize | aws-select
}

function aws-ssm-parameter-select-name() {
    aws-ssm-parameter-select | aws-field 1
}
