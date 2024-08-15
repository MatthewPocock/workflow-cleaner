#!/bin/bash

repo="MatthewPocock/workflow-cleaner"

select_workflow() {
  gh api --paginate "/repos/$repo/actions/workflows" \
    | jq -r '.workflows[] | [.id, .name] | @tsv' \
    | fzf --multi
}

select_runs() {
  while IFS=$'\t' read -r id name; do
    gh api --paginate "/repos/$repo/actions/workflows/$id/runs" \
      | jq -r '.workflow_runs[] | [.id, .name] | @tsv'
  done
}

delete_run() {
  while IFS=$'\t' read -r id name; do
    echo "Deleting run: $name - $id"
    gh api -X DELETE "/repos/$repo/actions/runs/$id" \
     && echo "Deleted ✅" \
     || echo "Failed! ❌"
    sleep .1
  done
}

main() {
  select_workflow | select_runs | delete_run
}

main
