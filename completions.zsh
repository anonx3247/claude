# Zsh completion for cft and cftr
# Install: Copy to ~/.zsh/completions/_cft and ~/.zsh/completions/_cftr
# Or source directly in ~/.zshrc: source /path/to/completions.zsh

#compdef cft

_cft() {
  local -a branches
  
  # Get list of git branches (excluding current and main/master)
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local current_branch=$(git branch --show-current 2>/dev/null)
    branches=(${(f)"$(git branch --format='%(refname:short)' | grep -v "^${current_branch}$" | grep -v '^main$' | grep -v '^master$')"})
    
    _arguments \
      '1:branch name:->branch' \
      && return 0
    
    case $state in
      branch)
        # Suggest existing branches and allow custom input
        _alternative \
          'branches:existing branch:compadd -a branches' \
          'custom:new branch name:_message "new branch name"'
        ;;
    esac
  else
    _message "not in a git repository"
  fi
}

#compdef cftr

_cftr() {
  local -a worktree_branches
  
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local project_dir=$(git rev-parse --show-toplevel)
    local project=$(basename "$project_dir")
    local parent_dir=$(dirname "$project_dir")
    
    # Find worktrees that match the pattern
    worktree_branches=()
    for dir in "$parent_dir"/"$project"-*; do
      if [ -d "$dir" ]; then
        local branch_name=${dir##*"$project"-}
        worktree_branches+=("$branch_name")
      fi
    done
    
    _arguments \
      '1:worktree branch:->worktree' \
      && return 0
    
    case $state in
      worktree)
        if [ ${#worktree_branches[@]} -gt 0 ]; then
          _describe 'worktree branches' worktree_branches
        else
          _message "no worktrees found"
        fi
        ;;
    esac
  else
    _message "not in a git repository"
  fi
}

# Register completions
compdef _cft cft
compdef _cftr cftr
