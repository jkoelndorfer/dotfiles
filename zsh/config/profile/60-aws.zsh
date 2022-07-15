_aws_version_output=$(aws --version 2>&1 | grep -E '^aws-cli/')
if [[ "$_aws_version_output" =~ '^\s*aws-cli/([0-9]+)\.' ]]; then
    AWS_CLI_VERSION=${match[1]}
else
    AWS_CLI_VERSION='?'
fi
export AWS_CLI_VERSION
unset _aws_version_output
