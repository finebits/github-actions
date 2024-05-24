# github-actions

[![GitHub release](https://img.shields.io/github/release/finebits/github-actions.svg)](https://GitHub.com/finebits/github-actions/tags/)
[![License](https://img.shields.io/github/license/finebits/github-actions.svg)](https://github.com/finebits/github-actions/blob/main/LICENSE)
[![Main branch: check](https://img.shields.io/github/actions/workflow/status/finebits/github-actions/check-actions.yml?branch=main&logo=github&label=main:%20check)](https://github.com/finebits/github-actions/actions/workflows/check-actions.yml?query=branch%3Amain)
[![Develop branch: check](https://img.shields.io/github/actions/workflow/status/finebits/github-actions/check-actions.yml?branch=develop&logo=github&label=develop:%20check)](https://github.com/finebits/github-actions/actions/workflows/check-actions.yml?query=branch%3Adevelop)

## Overview

 1. [Action 'version-number'](#action-version-number)
    - [Summary](#summary)
    - [Using](#using)
    - [Action inputs](#action-inputs)
    - [Action outputs](#action-outputs)
 2. [Action 'badges/shields-io-badge'](#action-badgesshields-io-badge)
    - [Summary](#summary-1)
    - [Using](#using-1)
    - [Action inputs](#action-inputs-1)
    - [Action outputs](#action-outputs-1)
 3. [Action 'badges/coverlet-coverage-badge'](#action-badgescoverlet-coverage-badge)
    - [Summary](#summary-2)
    - [Using](#using-2)
    - [Action inputs](#action-inputs-2)
    - [Action outputs](#action-outputs-2)
 4. [Action 'pack-nuget'](#action-pack-nuget)
    - [Summary](#summary-3)
    - [Using](#using-3)
    - [Action inputs](#action-inputs-3)
    - [Action outputs](#action-outputs-3)
 5. [Action 'upload-release-asset'](#action-upload-release-asset)
    - [Summary](#summary-4)
    - [Using](#using-4)
    - [Action inputs](#action-inputs-4)
    - [Action outputs](#action-outputs-4)

## Action `version-number`

### Summary

Gets a version number using a git tag, a git commit, a github workflow context.

### Using

```yaml
    - id: version-number
      uses: finebits/github-actions/version-number@v1

    - name: 
      run: |
        echo "Current version: ${{ steps.version-number.outputs.semantic-version-1 }}"
```

### Action inputs

Action has no inputs.

### Action outputs

- `build` - contains the workflow run number (look at [github action context](https://docs.github.com/en/actions/learn-github-actions/contexts#github-context));
- `attempt` - contains the workflow re-run number (look at [github action context](https://docs.github.com/en/actions/learn-github-actions/contexts#github-context));
- `today` - contains the date of the workflow execution in the format `yymmdd`;
- `githash` - contains the git commit hash;

If there is **tag** in the format `v{major}[.{minor}[.{patch}]][-{suffix}]` (ex. v1.2-beta) then

- `major` - contains the value of the **major** component of the version number, default value 1;
- `minor` - contains the value of the **minor** component of the version number, default value 0;
- `patch` - contains the value of the **patch** component of the version number, default value 0;
- `suffix` - contains the **suffix** version, it can be empty;

Preset version formats:

- `build-version` - version format: `{major}.{minor}.{patch}.{build}`
- `suffix-version` - version format: `{major}.{minor}.{patch}.{build}[-{suffix}]`
- `semantic-version-1` - version format: `{major}.{minor}.{patch}[-{suffix}]`
- `semantic-version-2` - version format: `{major}.{minor}.{patch}[-{suffix}]+{build}.{attempt}`
- `build-githash-version` - version format: `{major}.{minor}.{patch}.{build}+{githash}`
- `suffix-githash-version` - version format: `{major}.{minor}.{patch}.{build}[-{suffix}]+{githash}`
- `semantic-githash-version-2` - version format: `{major}.{minor}.{patch}[-{suffix}]+{build}.{attempt}.{githash}`

## Action `badges/shields-io-badge`

### Summary

It generates [Shields.io endpoint badge](https://shields.io/badges/endpoint-badge). Example badge: <sub><sub>![Shields.io badge](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/finebits-github/74f6d448f4f568a286d4622e92afbc75/raw/github-actions-shields-io-badge.json)</sub></sub>

### Using

1. Github Gist:
    - [Create secret gist](https://gist.github.com);
    - Copy `gist-id` to new repository or organization variables (ex: variable name `GIST_ID`).
2. Personal access tokens:
    - [Generate new token](https://github.com/settings/tokens);
    - Add `Gists` permission;
    - Copy token value to new repository or organization secret (ex: secret name `TOKEN_GITHUB_GIST`).
3. Action `shields-io-badge` can be added to the github workflow:

```yaml
- id: shields-io-badge
  uses: finebits/github-actions/badges/shields-io-badge@v1
  with:
    label: shields.io
    label-color: lightblue
    message: badge
    message-color: gold
    logo: github
    logo-color: blue
    style: flat
    gist-filename: "shields-io-badge.json"
    gist-id: ${{ vars.GIST_ID }}
    gist-auth-token: ${{ secrets.TOKEN_GITHUB_GIST }}

- name: Badge link
  run: |
    echo "Current version: ${{ steps.shields-io-badge.outputs.badge-link }}"
```

### Action inputs

- `label` - (required) The left side text of the badge, it might be empty;
- `message` - (required) The right side text, it can't be empty;
- `label-color` - Background color of the left part (hex, rgb, rgba, hsl, hsla and css named colors supported), default: grey;
- `message-color` - Background color of the right part (hex, rgb, rgba, hsl, hsla and css named colors supported), default: lightgrey;
- `is-error` - True to treat this as an error badge, default: false;
- `logo` - One of the [named logos](https://github.com/simple-icons/simple-icons/blob/master/slugs.md) supported by Shields, default: none;
- `logo-svg` - An SVG string containing a custom logo, default: none;
- `logo-color` - Supported for named logos and Shields logos, default: none;
- `logo-width` - Logo width, default: none;
- `logo-position` - Logo position, default: none;
- `style` - The default template to use, default: flat;
- `badge-description` - gist file description;
- `gist-filename` - (required) The format name for the 'Github Gist' file that stores the badge's metadata;
- `gist-id` - (required) The unique identifier of the 'Github Gist' where badge metadata is stored;
- `gist-auth-token` - (required) Authentication token to update the the 'Github Gist';
- `gist-owner` - 'Github Gist' owner, default: ${{ github.repository_owner }}.

### Action outputs

- `badge-link` - markdown badge link.

## Action `badges/coverlet-coverage-badge`

### Summary

It creates test coverage [badges](https://shields.io/badges/endpoint-badge) from the `coverlet.collector` test report. Example badge: <sub><sub>![Shields.io badge](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/finebits-github/74f6d448f4f568a286d4622e92afbc75/raw/github-actions-total-test-coverage.json)</sub></sub>

### Using

1. Test project:
    - Add nuget [coverlet.collector v6.0.0](https://www.nuget.org/packages/coverlet.collector/6.0.0).
2. Github Gist:
    - [Create secret gist](https://gist.github.com);
    - Copy `gist-id` to new repository or organization variables (ex: variable name `GIST_ID`).
3. Personal access tokens:
    - [Generate new token](https://github.com/settings/tokens);
    - Add `Gists` permission;
    - Copy token value to new repository or organization secret (ex: secret name `TOKEN_GITHUB_GIST`).
4. Update the github workflow:

```yaml
- name: Test project.
  run: |
    dotnet test ./source/test.csproj --collect:"XPlat Code Coverage" --results-directory="./source/TestResults"

- id: coverlet-coverage-badge
  uses: finebits/github-actions/badges/coverlet-coverage-badge@v1
  with:
    report-root: ./source/TestResults/**/
    report-filename: coverage.cobertura.xml
    gist-filename-format: "${{ github.event.repository.name }}-{0}-test-coverage.json"
    gist-id: ${{ vars.GIST_ID }}
    gist-auth-token: ${{ secrets.TOKEN_GITHUB_GIST }}

- name: Badges
  run: |
    json='${{ steps.coverlet-coverage-badge.outputs.badges-links }}'

    len=$(echo $json | jq '. | length')
    for ((i=0; i<$len; i++)); do
      echo -e "Badge link #"$i" $(echo $json | jq -r '.['$i']')\n"
    done
```

### Action inputs

- `label` - The badge label, default: "Test coverage";
- `package-label-format` - The label format of the package badges, default: "{0}: test coverage";
- `label-color` - Background color of the left part (hex, rgb, rgba, hsl, hsla and css named colors supported), default: grey;
- `logo` - One of the [named logos](https://github.com/simple-icons/simple-icons/blob/master/slugs.md) supported by Shields, default: none;
- `logo-svg` - An SVG string containing a custom logo, default: none;
- `logo-color` - Supported for named logos and Shields logos, default: none;
- `style` - The default template to use, default: flat;
- `gist-filename-format` - The format name for the 'Github Gist' file that stores the badge's metadata, default: "{0}-test-coverage.json";
- `report-root` - (required) Report root directory;
- `report-filename` - Report filename, default: "coverage.cobertura.xml";
- `gist-id` - (required) The unique identifier of the 'Github Gist' where badge metadata is stored;
- `gist-auth-token` - (required) Authentication token to update the the 'Github Gist;
- `gist-owner` - 'Github Gist' owner, default: ${{ github.repository_owner }}.

### Action outputs

- `badges-links` - contains a json array of markdown badges links. Test coverage badges by packages and total.

## Action `pack-nuget`

### Summary

It packs the project into a NuGet package. Also **pack-nuget** action can:

- sign the NuGet package;
- push to **nuget.org** and/or **nuget.pkg.github.com**;
- save the NuGet artifact.

### Using

```yaml
  - name: Pack
    uses: finebits/github-actions/pack-nuget@v1
    with:
        project: ./source/Hello.Nuget.csproj
        configuration: Release
        upload-artifact: true
        artifact-name: Hello.Nuget
        push-to-nuget: true
        nuget-apikey: ${{ secrets.NUGET_APIKEY }}
        push-to-github: true
        github-token: ${{ secrets.TOKEN_GITHUB_PACKAGE }}
        github-owner: ${{ github.repository_owner }}
        certificate: ${{ secrets.NUGET_BASE64_CERT }}
        certificate-password: ${{ secrets.NUGET_CERT_PASSWORD }}
```

### Action inputs

- `project` - (required) Project file for NuGet packaging;
- `configuration` - (required) Defines the build configuration;
- `upload-artifact` - The **true** value allows you to save the NuGet artifact, default: false;
- `artifact-name` - Defines the artifact file name, default: nuget;
- `push-to-nuget` - The **true** value allows you to push the nuget to **nuget.org**, default: false;
- `nuget-apikey` - The API key for nuget.org;
- `push-to-github` - The **true** value allows you to push the nuget to **nuget.pkg.github.com**, default: false;
- `github-token` - Github token (required **write:packages** scopes);
- `github-owner` - Github package owner;
- `certificate` - **Base64** encoded certificate;
- `certificate-password` - A password string;
- `file-version` - Redefines assembly version, default version calculated from git tag;
- `package-version` - Redefines the NuGet package version, default version calculated from git tag;

### Action outputs

- `artifact-full-name` - final nuget artifact name.

## Action `upload-release-asset`

### Summary

It uploads an asset to the existing release. Also **upload-release-asset** action can upload several assets if the path contains a pattern.

### Using

```yaml
  - name: Upload assets
    uses: finebits/github-actions/upload-release-asset@v1
    with:
      github-token: ${{ secrets.GITHUB_TOKEN }}
      tag: ${{ github.event.release.tag_name }}
      path: "assets/*"
```

### Action inputs

- `github-token` - (required) The github token must have **contents:write** permission;
- `path` - (required) Path to asset file. This can be a pattern-path to several files;
- `tag` - The name of the tag. To use the latest release, leave the value unset. default: unset;
- `github-api-version` - To specify a version of the Github REST API, default: 2022-11-28;
- `github-repository` - The name of the repository (ex: _finebits/github-actions_). The name is not case sensitive. default: ${GITHUB_REPOSITORY}

### Action outputs

 Action has no outputs.
