#!/bin/bash

terraform init -reconfigure
declare -a active_workspace

while IFS= read -r workspace; do
  workspace=$(echo "${workspace}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  if [[ -n "$workspace" && "$workspace" != *"*"* && "$workspace" != "default" ]]; then
    active_workspace+=("$workspace")
  fi
done < <(terraform workspace list | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

for workspace in "${active_workspace[@]}"; do
  echo "All workspace: $workspace"
done
