# See https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html

autoload bashcompinit
bashcompinit
complete -C /usr/bin/aws_completer aws
