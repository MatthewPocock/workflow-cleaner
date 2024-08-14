#!/bin/bash

repo="MatthewPocock/workflow-cleaner"

select_workflow() {
  gh api --paginate "/repos/$repo/actions/workflows" \
    | jq -r '.workflows[] | [.id, .name, .path] | @tsv' \
    | fzf
}

select_runs() {
  read -r id name
    gh api --paginate "/repos/$repo/actions/runs" \
    | jq -r --arg wid "$id" '.workflow_runs[] | select(.workflow_id==($wid|tonumber)) | "\(.id) \(.name)"'
}

delete_run() {
  id=$1
  name=$2
  echo "Deleting run: $id - $name"
  gh api -X DELETE "/repos/$repo/actions/runs/$id" --silent \
  && echo "Deleted ✅" \
  || echo "Failed! ❌"
}

delete_runs() {
  while read -r id name; do
    delete_run "$id" "$name"
    sleep 0.25
  done
}

select_workflow | select_runs | delete_runs