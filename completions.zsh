#compdef cft cftr

# Zsh completion for cft and cftr

_cft() {
    local curcontext="$curcontext" state line
    typeset -A opt_args
    
    _arguments -C \
        '1: :->branch' \
        '2: :->flag' \
        '*::arg:->args'
    
    case $state in
        branch)
            if git rev-parse --git-dir > /dev/null 2>&1; then
                local branches
                branches=(${(f)"$(git branch --all --format='%(refname:short)' 2>/dev/null | grep -v '^HEAD' | sed 's|^origin/||')"})
                _describe -t branches 'git branches' branches
            fi
            ;;
        flag)
            _values 'flags' \
                '--non-interactive[Skip editor and use provided prompt]' \
                '--help[Show usage information]'
            ;;
    esac
}

_cftr() {
    local curcontext="$curcontext" state line
    typeset -A opt_args
    
    _arguments -C \
        '1: :->branch' \
        '*::arg:->args'
    
    case $state in
        branch)
            if git rev-parse --git-dir > /dev/null 2>&1; then
                local branches
                branches=(${(f)"$(git branch --format='%(refname:short)' 2>/dev/null)"})
                _describe -t branches 'local branches' branches
            fi
            ;;
    esac
}

_cft "$@"
