# Bash completion for cft and cftr

_cft_complete() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Complete flags
    if [[ ${cur} == -* ]] ; then
        opts="--non-interactive --help"
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
    
    # Complete branch names from git
    if command -v git &> /dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
        local branches=$(git branch --all --format='%(refname:short)' 2>/dev/null | grep -v '^HEAD' | sed 's|^origin/||')
        COMPREPLY=( $(compgen -W "${branches}" -- ${cur}) )
    fi
}

_cftr_complete() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Complete flags
    if [[ ${cur} == -* ]] ; then
        opts="--help"
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
    
    # Complete existing worktree branches
    if command -v git &> /dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
        local branches=$(git branch --format='%(refname:short)' 2>/dev/null)
        COMPREPLY=( $(compgen -W "${branches}" -- ${cur}) )
    fi
}

# Register completions
complete -F _cft_complete cft
complete -F _cftr_complete cftr
