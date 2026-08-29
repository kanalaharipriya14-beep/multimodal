#compdef multivision multivision-backup multivision-calendar multivision-contacts multivision-cookbook multivision-docs multivision-gallery multivision-mail multivision-mcp multivision-memory multivision-notes multivision-personal multivision-preset multivision-research multivision-sessions multivision-signature multivision-skills multivision-tasks multivision-theme multivision-webhook
# Zsh tab-completion for the multivision umbrella + sub-CLIs.
#
# Drop in any directory on $fpath, e.g.:
#     fpath=(/path/to/multivision-ui/scripts/_completion $fpath)
#     autoload -U compinit; compinit
#
# Then `multivision <tab>` completes subcommands; `multivision mail <tab>`
# completes mail subcommands; `multivision-mail <tab>` works the same.

_multivision_scripts_dir() {
    local self="${(%):-%x}"
    while [[ -L "$self" ]]; do self="$(readlink "$self")"; done
    cd "${self:h}/.." && pwd
}

typeset -gA _multivision_subs

_multivision_refresh() {
    _multivision_subs=()
    local dir="$(_multivision_scripts_dir)"
    local py="$dir/../venv/bin/python"
    [[ -x "$py" ]] || py="$(command -v python3)"
    local f sub help_out commands
    for f in "$dir"/multivision-*; do
        [[ -x "$f" ]] || continue
        case "$f" in
            *.bak|*.pyc|*.pre-*) continue ;;
        esac
        sub="${${f:t}#multivision-}"
        help_out=$("$py" "$f" --help 2>/dev/null) || continue
        commands=$(echo "$help_out" | grep -oE '\{[a-z0-9_,-]+\}' | head -1 \
            | tr -d '{}' | tr ',' ' ')
        _multivision_subs[$sub]="$commands"
    done
}

_multivision() {
    [[ ${#_multivision_subs} -eq 0 ]] && _multivision_refresh

    local cmd="${words[1]}"

    if [[ "$cmd" == "multivision" ]]; then
        if (( CURRENT == 2 )); then
            local -a subs=(${(k)_multivision_subs} help)
            _describe 'subcommand' subs
            return
        fi
        local sub="${words[2]}"
        if [[ "$sub" == "help" ]] && (( CURRENT == 3 )); then
            local -a subs=(${(k)_multivision_subs})
            _describe 'subcommand' subs
            return
        fi
        if (( CURRENT == 3 )); then
            local -a sc=(${(s/ /)_multivision_subs[$sub]})
            _describe 'command' sc
            return
        fi
        return
    fi

    # multivision-foo <tab>
    local sub="${cmd#multivision-}"
    if (( CURRENT == 2 )); then
        local -a sc=(${(s/ /)_multivision_subs[$sub]})
        _describe 'command' sc
        return
    fi
}

_multivision "$@"
