#!/bin/bash

repo="MatthewPocock/workflow-cleaner"

select_workflow() {
  gh api --paginate "/repos/$repo/actions/workflows" \
    | jq -r '.workflows[] | [.id, .name, .path] | @tsv' \
    | fzf --multi
}

select_runs() {
  workflow_ids=()
  while read -r id name; do
    workflow_ids+=("$id")
  done

  gh api --paginate "/repos/$repo/actions/runs" \
    | jq -r --argjson wids "$(printf '%s\n' "${workflow_ids[@]}" | jq -R . | jq -s .)" '
      .workflow_runs[]
      | select(.workflow_id as $wid | $wids | index($wid | tostring))
      | "\(.id) \(.name)"
    '
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