#!/bin/bash

terraform init -reconfigure
declare -a processed_workspaces
declare -a deleted_workspaces

while IFS= read -r workspace; do
  workspace=$(echo "${workspace}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  if [[ -n "$workspace" && "$workspace" != *"*"* && "$workspace" != "default" ]]; then
    processed_workspaces+=("$workspace")
  fi
done < <(terraform workspace list | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

last_index=$(( ${#processed_workspaces[@]}))

for (( i=0; i<$last_index; i++ )); do
  workspace="${processed_workspaces[$i]}"
  echo "Processing workspace: $workspace"
  terraform workspace select "${workspace}"

  current_time=$(date +%s%3N)
  last_modified=$(terraform output -raw last_modified)

  if [[ -z "$last_modified" || ! "$last_modified" =~ ^[0-9]+$ ]]; then
    last_modified=$(date +%s%3N)
    echo "Setting last_modified to the current timestamp."
  fi

  age=$(( (current_time - last_modified) / 60000 ))

  echo "${current_time} - ${last_modified}"
  echo $age

  if [ $age -gt 15 ]; then
    echo "$workspace environment is older than 15 minutes. Destroying..."

    deleted_workspaces+=("$workspace")

    terraform destroy -force || terraform destroy -auto-approve
    terraform workspace select default
    terraform workspace delete "${workspace}"
  else
    echo "$workspace environment is still within the 15-minute retention period."
  fi
done

for deleted_workspace in "${deleted_workspaces[@]}"; do
  echo "Deleted workspace: $deleted_workspace"
done
