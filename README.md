# GitHub Workflow Cleaner

A simple shell script to remove GitHub workflow runs in bulk via the CLI.

## Setup

1. Install prerequisites: [GitHub CLI](https://github.com/cli/cli), [jq](https://github.com/stedolan/jq), and [fzf](https://github.com/junegunn/fzf). For example, on macOS:
    ```bash
    brew install gh jq fzf
    ```

2. Set up a GitHub token (ensure you have the necessary permissions).

3. Run the script with the repository name as an argument (including the repo owner). For example:
    ```bash
    ./clean-workflows.sh MatthewPocock/workflow-cleaner
    ```

4. Use the `<up>` and `<down>` arrow keys to navigate the list of workflows, and select the ones to be deleted with `<tab>`.

5. Press `<enter>` to delete all runs from the selected workflows.

## Usage

```bash
./clean-workflows.sh <owner>/<repository>
```

## Acknowledgments
This project was inspired by:

- delete-gh-workflow-runs by jv-k

## License
This project is open source and available under the MIT License.
