#!/bin/bash

repo="MatthewPocock/workflow-cleaner"

select_workflow() {
  gh api --paginate "/repos/$repo/actions/workflows" \
    | jq -r '.workflows[] | [.id, .name, .path] | @tsv' \
    | fzf --multi
}

select_runs() {
  while read -r id name; do
    gh api --paginate "/repos/$repo/actions/workflows/$id/runs" \
      | jq -r '.workflow_runs[] | [.id, .name, .display_title] | @tsv'
  done
}

delete_run() {
  while IFS=$'\t' read -r id name display_title; do
    echo "Deleting run: $id - $name - $display_title"
      gh api -X DELETE "/repos/$repo/actions/runs/$id" --silent \
       && echo "Deleted ✅" \
       || echo "Failed! ❌"
    sleep .1
  done
}

main() {
  select_workflow | select_runs | delete_run
}

main
