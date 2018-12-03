_gen_fzf_default_opts() {
  source "$DOTFILE_DIR/colors/solarized-dark"

  export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$SOLARIZED_BASE3_TERM16,fg+:$SOLARIZED_BASE3_TERM16,bg+:$SOLARIZED_BASE1_TERM16,hl+:$SOLARIZED_BASE3_TERM16
    --color info:$SOLARIZED_YELLOW_TERM16,prompt:$SOLARIZED_BLUE_TERM16,pointer:$SOLARIZED_BASE3_TERM16
    --color marker:$SOLARIZED_BASE3_TERM16,spinner:$SOLARIZED_BLUE_TERM16
    --no-bold
  "
}
_gen_fzf_default_opts
