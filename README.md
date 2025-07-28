# gickup-action
A GitHub Action for backing up any git repositories using gickup

## Usage
Create a `.github/gickup.yml` file in your repository with your preferred configuration:

```yml
# yaml-language-server: $schema=https://raw.githubusercontent.com/cooperspencer/gickup/refs/heads/main/gickup_spec.json
# Example gickup configuration
source:
  # Your source repository configuration goes here
destination:
  # Your source repository configuration goes here
```

> [!NOTE]
> You can use `.env`, `.vars` & `.secrets` in your configuration file to access environment variables, repository secrets, and GitHub Actions variables. This allows you to keep sensitive information out of your configuration file.

Please refer to the [gickup documentation](https://cooperspencer.github.io/gickup-documentation/category/configuration) for more information on how to configure your backup.

Create a `.github/workflows/backup.yml` file in your repository with the following content:
```yml
name: backup

on:
  push:
  workflow_dispatch:

jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Run gickup
      uses: socheatsok78/gickup-action@main
```

> [!NOTE]
> By default, the action will look for a `.github/gickup.yml` file in your repository. If you have a different configuration file, you can specify it using the `config` input. See the [Inputs](#inputs) section for more information.


## Inputs

- `config`: The path to the gickup configuration file. Default: `.github/gickup.yml`
- `dryrun`: Whether to run gickup in dry-run mode. Default: `false`
- `debug`: Whether to run gickup in debug mode. Default: `false`
