# Bash completion for cft and cftr
# Install: Copy to /etc/bash_completion.d/ or source in ~/.bashrc

_cft_completion() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  
  # Only complete the first argument
  if [ $COMP_CWORD -eq 1 ]; then
    # Get list of git branches if in a git repo
    if git rev-parse --git-dir > /dev/null 2>&1; then
      local branches=$(git branch --format='%(refname:short)' 2>/dev/null)
      COMPREPLY=( $(compgen -W "${branches}" -- ${cur}) )
    fi
  fi
  
  return 0
}

_cftr_completion() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  
  # Only complete the first argument
  if [ $COMP_CWORD -eq 1 ]; then
    # Get list of worktree directories
    if git rev-parse --git-dir > /dev/null 2>&1; then
      local project_dir=$(git rev-parse --show-toplevel)
      local project=$(basename "$project_dir")
      local parent_dir=$(dirname "$project_dir")
      
      # Find matching worktrees
      local worktrees=""
      for dir in "$parent_dir"/"$project"-*; do
        if [ -d "$dir" ]; then
          local branch_name=${dir##*"$project"-}
          worktrees="$worktrees $branch_name"
        fi
      done
      
      COMPREPLY=( $(compgen -W "${worktrees}" -- ${cur}) )
    fi
  fi
  
  return 0
}

# Register completions
complete -F _cft_completion cft
complete -F _cftr_completion cftr
