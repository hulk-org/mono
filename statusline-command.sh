#!/bin/sh
# Claude Code status line command
# Format: dir  model  N% ctx  branch

input=$(cat)

dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""' | xargs basename 2>/dev/null)
model=$(echo "$input" | jq -r '.model.display_name // ""')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Git branch (skip optional locks)
branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "."')" symbolic-ref --short HEAD 2>/dev/null || true)

parts=""

[ -n "$dir" ] && parts="$dir"

[ -n "$model" ] && parts="$parts  $model"

if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  parts="$parts  ${used_int}% ctx"
fi

[ -n "$branch" ] && parts="$parts  $branch"

printf "%s" "$parts"
