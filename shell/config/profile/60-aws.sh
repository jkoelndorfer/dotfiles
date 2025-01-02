source "${SH_LIB_DIR}/shell.sh"

_aws_version_output=$(aws --version 2>&1 | grep -E '^aws-cli/')
_aws_cli_regex='^\s*aws-cli/([0-9]+)\.'

if [[ "$_aws_version_output" =~ $_aws_cli_regex ]]; then
    AWS_CLI_VERSION=$(regex-match 1)
fi

if [[ -z "$AWS_CLI_VERSION" ]]; then
    AWS_CLI_VERSION='?'
fi
export AWS_CLI_VERSION
unset _aws_cli_regex
unset _aws_version_output
