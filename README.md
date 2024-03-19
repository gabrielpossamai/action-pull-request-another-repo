# Action pull request another repository 

This GitHub Action copies a folder from the current repository to a location in another repository and create a pull request

## Example Workflow

```yaml
    name: Pull Request Another Repository
    on: push

    jobs:
      pull-request:
        runs-on: ubuntu-latest
        steps:
        - name: Checkout
          uses: actions/checkout@v2

        - name: Create pull request
          uses: gabrielpossamai/action-pull-request-another-repo@main
          env:
            API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}
          with:
            source_folder: 'source-folder'
            destination_repo: 'user-name/repository-name'
            destination_folder: 'folder-name'
            destination_base_branch: 'branch-name'
            destination_head_branch: 'branch-name'
            pr_title: 'Pull Request Title'
            pr_body: 'Pull Request Body'
            commit_message: 'Commit Message'
            user_email: 'user-name@example.com'
            user_name: 'user-name'
            pull_request_reviewers: 'reviewers'
            github_server: 'github.com'
            recursive: 'true'
            allow_force_push: 'false'
            create_as_draft: 'false'
            clone_from_destination_base: 'false'
```

## Variables

* **source_folder**: The folder to be moved. Uses the same syntax as the `cp` command. Incude the path for any files not in the repositories root directory.
* **destination_repo**: The repository to place the file or directory in.
* **destination_folder**: [optional] The folder in the destination repository to place the file in, if not the root directory.
* **destination_base_branch**: [optional] The branch into which you want your code merged. Default is `main`.
* **destination_head_branch**: The branch to create to push the changes. Cannot be `master` or `main`.
* **pr_title**: [optional] The title of the pull request.
* **pr_body**: [optional] The body of the pull request.
* **commit_message**: [optional] The commit message. Default is `Update from ${{ github.repository }}`.
* **user_email**: The GitHub user email associated with the API token secret.
* **user_name**: The GitHub username associated with the API token secret.
* **pull_request_reviewers**: [optional] The pull request reviewers. It can be only one (just like 'reviewer') or many (just like 'reviewer1,reviewer2,...')
* **github_server**: [optional] The GitHub server. Default is `github.com`.
* **recursive**: [optional] If `false` specified, the action will not copy the files recursively. Default is `true`.
* **allow_force_push**: [optional] If `true` specified, the action will force push the changes to the destination repository. Push with `--force` flag. Default is `false`.
* **create_as_draft**: [optional] If `true` specified, the action will create the pull request as a draft. Default is `false`.
* **clone_from_destination_base**: [optional] If `true` specified, the action will clone the destination repository from the base branch (the same as clone, checkout and pull the destination base branch). Default is `false`.

## ENV

* **API_TOKEN_GITHUB**: You must create a personal access token in your account. Follow the link:

[Personal access token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token)

> You must select the scopes: 'repo = Full control of private repositories', 'admin:org = read:org' and 'write:discussion = Read:discussion';


## Behavior Notes

The action will create any destination paths if they don't exist. It will also overwrite existing files if they already exist in the locations being copied to. It will not delete the entire destination repository.

## Contributors
* [Gabriel Possamai](https://github.com/gabrielpossamai)
* [Willian Itiho Amano](https://github.com/Itiho)
* [Piotr Joński](https://github.com/sta-szek)
* [mattcollier](https://github.com/mattcollier)
* [TATSUNO “Taz” Yasuhiro](https://github.com/exoego)
* [aswindevs](https://github.com/aswindevs07)
* [Jacopo Carlini](https://github.com/jacopocarlini)
* [Mike Forsberg](https://github.com/bigmikef)
* [Alexander Rasputin](https://github.com/Ehrax)
