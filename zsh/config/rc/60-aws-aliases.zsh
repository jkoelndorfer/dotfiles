# Dumps out all of the EC2 instances with the given name.
function aws-ec2-instances-named() {
    local name="$1"
    aws ec2 describe-instances --filters "Name=tag:Name,Values=$name"
}

function aws-ec2-instance-names() {
    aws ec2 describe-instances --query 'Reservations[*].Instances[*].Tags[?Key==`Name`].Value' | jq -r '.[][0][0]' | sort -u
}

function aws-ec2-instance-public-ip() {
    local instance_id=$1

    aws ec2 describe-instances \
        --instance-id "$instance_id" \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text
}

function aws-ami-select() {
    local tab="$(echo -e '\t')"
    {
        echo -e "Name\tImage ID\tCreation Date"
        aws ec2 describe-images --owners self | jq -r '.Images[] | [.Name, .ImageId, .CreationDate] | join("\t")' | sort -k3 -r -t "$tab"
    } | column -t -o "$tab" -s "$tab" | fzf --header-lines 1 | awk -F"$tab" '{ print $2 }'
}

function aws-asg-ls() {
    aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].AutoScalingGroupName' --output text |
        sed -e 's/\t/\n/g' | sort
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
        --output text | sed -e 's/\t/\n/g'
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

function aws-lt-set-ami() {
    local lt_name=$1
    local ami_id=$2

    aws ec2 create-launch-template-version --launch-template-name "$lt_name" --source-version '$Latest' --launch-template-data '{"ImageId": "'"$ami_id"'"}'
}

function aws-ssm-parameter-ls() {
    aws ssm describe-parameters --query 'Parameters[].Name' --output text | sed -e 's/\t/\n/g' | sort
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
    local tab=$(echo -e '\t')
    aws ssm describe-parameters |
        jq -r '.Parameters[] | (.Name + "\t" + .Description)' |
        column -t -s "$tab" | fzf | awk '{ print $1 }'
}
