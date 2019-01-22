# Dumps out all of the EC2 instances with the given name.
function ec2_instances_named() {
    local name="$1"
    aws ec2 describe-instances --filters "Name=tag:Name,Values=$name"
}

function ec2_instance_names() {
    aws ec2 describe-instances --query 'Reservations[*].Instances[*].Tags[?Key==`Name`].Value' | jq -r '.[][0][0]' | sort -u
}
