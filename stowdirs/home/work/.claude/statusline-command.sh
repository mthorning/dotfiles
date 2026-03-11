#!/bin/bash

input=$(cat)

parts=()

# Jujutsu status (if in a jj repo)
if jj-starship detect &>/dev/null; then
  jj_status=$(jj-starship 2>/dev/null)
  [[ -n "$jj_status" ]] && parts+=("$jj_status")
fi

# Kubernetes context
k8s_context=$(kubectl config current-context 2>/dev/null)
if [[ -n "$k8s_context" ]]; then
  parts+=("☸ $k8s_context")
fi

# Current directory (shortened)
parts+=("${PWD/#$HOME/~}")

# Model and context window
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

if [[ -n "$model" ]]; then
  if [[ -n "$used" && "$used" != "null" ]]; then
    used_int=$(printf "%.0f" "$used")
    meta_part=$(printf " [󰚩 %s | ctx: %s%%]" "$model" "$used_int")
  else
    meta_part=$(printf " [󰚩 %s]" "$model")
  fi
  parts+=("${meta_part}")
fi

# Join with pipes
IFS=' | '
echo "${parts[*]}"
