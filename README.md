# gickup-action
A GitHub Action for backing up any git repositories using gickup

## Usage
Create a `.gickup/gickup.yml` file in your repository with your preferred configuration:

```yml
# yaml-language-server: $schema=https://raw.githubusercontent.com/cooperspencer/gickup/refs/heads/main/gickup_spec.json
# Example gickup configuration
source:
  # Your source repository configuration goes here
destination:
  # Your source repository configuration goes here
```

Please refer to the [gickup documentation](https://cooperspencer.github.io/gickup-documentation/category/configuration) for more information on how to configure your backup.

Create a `.github/workflows/gickup.yml` file in your repository with the following content:
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

## Accessing GitHub workflow `env`, `vars`, and `secrets`

You can access GitHub workflow `env`, `vars`, and `secrets` in your gickup configuration file by using the following syntax:

```yaml
# .gickup/gickup.yml

# Example gickup configuration with GitHub workflow env, vars, and secrets
source:
  github:
    - user: actions
      token: ${{ .secret.github_token }}
destination:
  # Your destination repository configuration goes here
```

```yml
# .github/workflows/gickup.yml

# ...
jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
    # ...
    - name: Run gickup
      uses: socheatsok78/gickup-action@main
      with:
        # Add the following inputs to pass env, vars, and secrets
        # to your gickup configuration
        env: ${{ toJson(env) }}
        vars: ${{ toJson(vars) }}
        secrets: ${{ toJson(secrets) }}
```
