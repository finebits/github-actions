# github-actions

[![GitHub release](https://img.shields.io/github/release/finebits/github-actions.svg)](https://GitHub.com/finebits/github-actions/tags/)
[![License](https://img.shields.io/github/license/finebits/github-actions.svg)](https://github.com/finebits/github-actions/blob/main/LICENSE)
[![Check action](https://img.shields.io/github/actions/workflow/status/finebits/github-actions/check-actions.yml?branch=main&event=push&logo=github&label=check)](https://github.com/finebits/github-actions/actions/workflows/check-actions.yml?query=branch%3Amain+event%3Apush)
[![YAML validation](https://img.shields.io/github/actions/workflow/status/finebits/github-actions/yamllint-validation.yml?branch=main&event=push&logo=yaml&label=validation)](https://github.com/finebits/github-actions/actions/workflows/yamllint-validation.yml?query=branch%3Amain+event%3Apush)

## Overview

- [Action 'badges/coverlet-coverage-badge'](#action-badgescoverlet-coverage-badge)
- [Action 'badges/shields-io-badge'](#action-badgesshields-io-badge)
- [Action 'devhub/uno-platform/read-manifest'](#action-devhubuno-platformread-manifest)
- [Action 'devhub/uno-platform/setup'](#action-devhubuno-platformsetup)
- [Action 'package/appimage/pack'](#action-packageappimagepack)
- [Action 'package/appimage/setup-appimagetool'](#action-packageappimagesetup-appimagetool)
- [Action 'package/nuget/pack'](#action-packagenugetpack)
- [Action 'toolset/file/read'](#action-toolsetfileread)
- [Action 'toolset/file/replace-text'](#action-toolsetfilereplace-text)
- [Action 'toolset/assign-version'](#action-toolsetassign-version)
- [Action 'toolset/github/upload-release-asset'](#action-toolsetgithubupload-release-asset)
- [Action 'toolset/select-configuration'](#action-toolsetselect-configuration)

## Action `badges/coverlet-coverage-badge`

### Summary

This creates test coverage [badges](https://shields.io/badges/endpoint-badge) from the `coverlet.collector` test report. Example badge: <sub><sub>![Shields.io badge](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/finebits-github/74f6d448f4f568a286d4622e92afbc75/raw/github-actions-total-test-coverage.json)</sub></sub>

### Using

1. Test project:
    - Add nuget [coverlet.collector](https://www.nuget.org/packages/coverlet.collector).
2. Github Gist:
    - [Create secret gist](https://gist.github.com);
    - Copy `gist-id` to new repository or organization variables (e.g., variable name `GIST_ID`).
3. Personal access tokens:
    - [Generate new token](https://github.com/settings/tokens);
    - Add `Gists` permission;
    - Copy token value to new repository or organization secret (e.g., secret name `TOKEN_GITHUB_GIST`).
4. Action `badges/coverlet-coverage-badge` can be added to the Github workflow:

```yaml
- shell: bash
  run: |
    dotnet test ./source/test.csproj --collect:"XPlat Code Coverage" --results-directory="./source/TestResults"

- id: coverlet-coverage-badge
  uses: finebits/github-actions/badges/coverlet-coverage-badge@v3
  with:
    report-root: ./source/TestResults/**/
    report-filename: coverage.cobertura.xml
    gist-filename-format: "${{ github.event.repository.name }}-{0}-test-coverage.json"
    gist-id: ${{ vars.GIST_ID }}
    gist-auth-token: ${{ secrets.TOKEN_GITHUB_GIST }}

- shell: bash
  run: |
    json='${{ steps.coverlet-coverage-badge.outputs.badges-links }}'

    len=$(echo $json | jq '. | length')
    for ((i=0; i<$len; i++)); do
      echo -e "Badge link #"$i" $(echo $json | jq -r '.['$i']')\n"
    done
```

### Action inputs

- `label` - The badge label, default: _"Test coverage"_
- `package-label-format` - The label format of the package badges, default: _"{0}: test coverage"_
- `label-color` - Background color of the left part (hex, rgb, rgba, hsl, hsla and css named colors supported), default: _grey_
- `logo` - One of the [named logos](https://github.com/simple-icons/simple-icons/blob/master/slugs.md) supported by Shields
- `logo-svg` - An SVG string containing a custom logo
- `logo-color` - Supported for named logos and Shields logos
- `style` - The default template to use, default: _flat_
- `gist-filename-format` - The format name for the 'Github Gist' file that stores the badge's metadata, default: _"{0}-test-coverage.json"_
- `report-root` - **(required)** Report root directory
- `report-filename` - Report filename, default: _"coverage.cobertura.xml"_
- `gist-id` - **(required)** The unique identifier of the 'Github Gist' where badge metadata is stored
- `gist-auth-token` - **(required)** Authentication token to update the the 'Github Gist
- `gist-owner` - 'Github Gist' owner, default: _${{ github.repository_owner }}_

### Action outputs

- `badges-links` - contains a json array of markdown badges links

## Action `badges/shields-io-badge`

### Summary

This generates [Shields.io endpoint badge](https://shields.io/badges/endpoint-badge). Example badge: <sub><sub>![Shields.io badge](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/finebits-github/74f6d448f4f568a286d4622e92afbc75/raw/github-actions-shields-io-badge.json)</sub></sub>

### Using

1. Github Gist:
    - [Create secret gist](https://gist.github.com);
    - Copy `gist-id` to new repository or organization variables (e.g., variable name `GIST_ID`).
2. Personal access tokens:
    - [Generate new token](https://github.com/settings/tokens);
    - Add `Gists` permission;
    - Copy token value to new repository or organization secret (e.g., secret name `TOKEN_GITHUB_GIST`).
3. Action `badges/shields-io-badge` can be added to the Github workflow:

```yaml
- id: shields-io-badge
  uses: finebits/github-actions/badges/shields-io-badge@v3
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

- shell: bash
  run: |
    echo "Badge: ${{ steps.shields-io-badge.outputs.badge-link }}"
```

### Action inputs

- `label` - **(required)** The left side text of the badge, it might be empty
- `message` - **(required)** The right side text, it can't be empty
- `label-color` - Background color of the left part (hex, rgb, rgba, hsl, hsla and css named colors supported), default: _grey_
- `message-color` - Background color of the right part (hex, rgb, rgba, hsl, hsla and css named colors supported), default: _lightgrey_
- `is-error` - True to treat this as an error badge, default: _false_
- `logo` - One of the [named logos](https://github.com/simple-icons/simple-icons/blob/master/slugs.md) supported by Shields
- `logo-svg` - An SVG string containing a custom logo
- `logo-color` - Supported for named logos and Shields logos
- `logo-width` - Logo width
- `logo-position` - Logo position
- `style` - The default template to use, default: _flat_
- `badge-description` - gist file description
- `gist-filename` - **(required)** The format name for the 'Github Gist' file that stores the badge's metadata
- `gist-id` - **(required)** The unique identifier of the 'Github Gist' where badge metadata is stored
- `gist-auth-token` - **(required)** Authentication token to update the the 'Github Gist'
- `gist-owner` - 'Github Gist' owner, default: _${{ github.repository_owner }}_

### Action outputs

- `badge-link` - markdown badge link

## Action `devhub/uno-platform/read-manifest`

### Summary

Read the Uno Platform setup manifest from the `uno-check` tool.

### Using

> [!IMPORTANT]
> **Prerequisites:** .NET SDK (i.e., _uses: actions/setup-dotnet_)

```yaml
- id: uno-check-manifest
  uses: finebits/github-actions/devhub/uno-platform/read-manifest@v3

- shell: bash
  run: |
    dotnet_version="${{ fromJSON(steps.uno-check-manifest.outputs.content).check.variables.DOTNET_SDK_VERSION }}"
```

### Action inputs

- `uno-check-manifest` - Specific manifest URL of the **uno-check** tool
- `uno-check-version` - Specific version of the **uno-check** tool

### Action outputs

- `content` - Contents of the Uno Platform manifest file

## Action `devhub/uno-platform/setup`

### Summary

Sets up the Uno Platform and its dependencies.

### Using

```yaml
- uses: finebits/github-actions/devhub/uno-platform/setup@v3
```

### Action inputs

- `uno-sdk-version` - Specifies the version of the Uno.Sdk
- `uno-check-skip` - Skips a checkup by name or ID as listed in uno-check list, default: _xcode vswin vsmac windowshyperv edgewebview2 androidemulator dotnetnewunotemplates_
- `uno-check-manifest` - Specifies the manifest URL of the 'uno-check' tool
- `uno-check-version` - Specifies the version of the 'uno-check' tool
- `default-dotnet-version` - Specifies the version of dotnet to install by default, default: _8.x_
- `dotnet-install-dir` - Specifies the location of the dotnet. This allows you to ignore the pre-installed dotnet, default: _${{ github.workspace }}/.dotnet_

### Action outputs

_Action has no outputs._

## Action `package/appimage/pack`

### Summary

This packages a desktop application as an [AppImage](https://appimage.org/) that runs on common Linux-based operating systems such as RHEL, CentOS, Ubuntu, Fedora, Debian and etc.

### Using

> [!IMPORTANT]
> This action can only be used on Linux (i.e., _runs-on: ubuntu-latest_).

```yaml
jobs:
  appimage:
    runs-on: ubuntu-latest
```

Action `package/appimage/pack` can be used in the Github workflow:

```yaml
- uses: finebits/github-actions/package/appimage/pack@v3
  with:
    package-runtime: x86_64
    package-app-dir: ./.publish/appimage-package/AppDir
    package-output-dir: ./publish/output/packages
```

### Action inputs

- `package-app-dir` - **(required)** Path to Package [AppDir](https://docs.appimage.org/introduction/concepts.html#appdirs) directory
- `package-runtime` - The package runtime. It can take one of the values: [aarch64, armhf, i686, x86_64], default: _x86_64_
- `package-output-dir` - Path to output directory, default: _./.output/_

### Action outputs

- `package` - Path to file *.AppImage

## Action `package/appimage/setup-appimagetool`

### Summary

This setups [appimagetool](https://github.com/AppImage/appimagetool), its [runtimes](https://github.com/AppImage/type2-runtime) and [static tools](https://github.com/probonopd/static-tools).

### Using

> [!IMPORTANT]
> This action can only be used on Linux (i.e., _runs-on: ubuntu-latest_).

```yaml
jobs:
  appimage:
    runs-on: ubuntu-latest
```

Action `package/appimage/setup-appimagetool` can be used in the Github workflow:

```yaml
- uses: finebits/github-actions/package/appimage/setup-appimagetool@v3
```

### Action inputs

_Action has no inputs._

### Action outputs

_Action has no outputs._

## Action `package/nuget/pack`

### Summary

This packages the project into a NuGet package. Also **pack-nuget** action can:

- sign the NuGet package
- push to **nuget.org** and/or **nuget.pkg.github.com**
- save the NuGet artifact to Github

### Using

```yaml
- uses: finebits/github-actions/package/nuget/pack@v3
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

- `project` - **(required)** Project file for NuGet packaging
- `configuration` - **(required)** Defines the build configuration
- `upload-artifact` - The **true** value allows you to save the NuGet artifact, default: _false_
- `artifact-name` - Defines the artifact file name, default: _nuget_
- `push-to-nuget` - The **true** value allows you to push the nuget to **nuget.org**, default: _false_
- `nuget-apikey` - The API key for nuget.org
- `push-to-github` - The **true** value allows you to push the nuget to **nuget.pkg.github.com**, default: _false_
- `github-token` - Github token (required **write:packages** scopes)
- `github-owner` - Github package owner
- `certificate` - **Base64** encoded certificate
- `certificate-password` - A password string
- `file-version` - Redefines assembly version, default version calculated from git tag
- `package-version` - Redefines the NuGet package version, default version calculated from git tag

### Action outputs

- `artifact-full-name` - final nuget artifact name

## Action `toolset/file/read`

### Summary

This reads the contents of a file and saves it in the output.

### Using

Action `toolset/file/read` can read file in the Github workflow:

```yaml
- id: read-config
  uses: finebits/github-actions/toolset/file/read@v3
  with:
    url: http://site.com/config.json
    file: config.json

- shell: bash
  run: |
    option="${{ fromJSON(steps.read-config.outputs.content).option }}"
```

where **config.json**:

```json
{ 
  "option":"value"
}
```

### Action inputs

- `url` - Link to file.
- `file` - Path to local file. This is used if the input `url` is empty or the http status is not OK(200).

### Action outputs

- `content` - file contents

## Action `toolset/file/replace-text`

### Summary

This replaces all occurrences of a **placeholder** with a given **value** string inside a file.

### Using

```yaml
- uses: finebits/github-actions/toolset/file/replace-text@v3
  with:
    file: ./source/hello.js
    find-what: <!placeholder>
    replace-with: "hello world"
```

### Action inputs

- `file` - **(required)** Path to source file
- `find-what` - **(required)** Replacement text
- `replace-with` - **(required)** Required text

### Action outputs

_Action has no outputs._

## Action `toolset/assign-version`

### Summary

This gets a version number using a git tag, a git commit, a Github workflow context.

### Using

```yaml
- id: version
  uses: finebits/github-actions/toolset/assign-version@v3

- shell: bash
  run: |
    echo "Current version: ${{ steps.version.outputs.preset-semantic-v1 }}"
```

### Action inputs

_Action has no inputs._

### Action outputs

- `run-number` - contains the run number of the workflow (look at [github action context](https://docs.github.com/en/actions/learn-github-actions/contexts#github-context))
- `run-attempt` - contains the re-run number of the workflow (look at [github action context](https://docs.github.com/en/actions/learn-github-actions/contexts#github-context))
- `today` - contains the date of the workflow execution in the format `yyyymmdd`
- `today-compact` - contains the date of the workflow execution in the format `yymmdd`
- `commit-hash` - contains the full SHA-1 hash of the latest commit in the current branch
- `commit-short-hash` - contains the short SHA-1 hash of the latest commit in the current branch
- `total-commits` - contains the number of commits for the current branch

If there is **tag** in the format `v{major}[.{minor}[.{patch}]][-{suffix}]` (e.g., v1.2-beta) then

- `major` - contains the value of the **major** component of the version number, default value 1
- `minor` - contains the value of the **minor** component of the version number, default value 0
- `patch` - contains the value of the **patch** component of the version number, default value 0
- `suffix` - contains the **suffix** version, it can be empty

Preset version formats:

- `preset-numeric` - version format: `{major}.{minor}.{patch}`
- `preset-semantic-v1` - version format: `{major}.{minor}.{patch}[-{suffix}]`
- `preset-semantic-v2` - version format: `{major}.{minor}.{patch}[-{suffix}]+{commit-hash}`
- `preset-semantic-v2-extended` - version format: `{major}.{minor}.{patch}[-{suffix}]+{today}.{run-number}.{run-attempt}.{commit-hash}`

## Action `toolset/github/upload-release-asset`

### Summary

It uploads an asset to the existing release. Also **upload-release-asset** action can upload several assets if the path contains a pattern.

### Using

```yaml
- uses: finebits/github-actions/toolset/github/upload-release-asset@v3
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    tag: ${{ github.event.release.tag_name }}
    path: "assets/*"
```

### Action inputs

- `github-token` - **(required)** The github token must have **contents:write** permission
- `path` - **(required)** Path to asset file. This can be a pattern-path to several files
- `tag` - The name of the tag. To use the latest release, leave the value unset. default: _unset_
- `github-api-version` - To specify a version of the Github REST API, default: _2022-11-28_
- `github-repository` - The name of the repository (e.g., _finebits/github-actions_). The name is not case sensitive. default: _${GITHUB_REPOSITORY}_

### Action outputs

 _Action has no outputs._

## Action `toolset/select-configuration`

### Summary

This allows you to select configurations from JSON by keywords.

### Using

The **config.json** file contains several configurations:

```json
[
  {
    "keywords":["A","B"],
    "option":"value-a"
  },
  {
    "keywords":["A","C"],
    "option":"value-b"
  },
  {
    "keywords":["C","B"],
    "option":"value-c"
  }
]
```

Action `toolset/select-configuration` can select a configuration in the Github workflow:

```yaml
- id: config
  uses: finebits/github-actions/toolset/select-configuration@v3
  with:
    json-file: config.json
    keywords: A B

- shell: bash
  run: |
    option="${{ fromJson(steps.config.outputs.config-json)[0].option }}"
```

Action `toolset/select-configuration` can be used as a source of strategy:

```yaml
jobs:
  prepare:
    runs-on: 'ubuntu-latest'
    outputs:
      matrix: ${{ steps.config.outputs.matrix }}
    steps:
      - id: config
        uses: finebits/github-actions/toolset/select-configuration@v3
        with:
          json-file: config.json
          keywords: A

  process:
    needs: prepare
    strategy:
      matrix: ${{ fromJson(needs.prepare.outputs.matrix) }}
```

### Action inputs

- `json` - JSON data. This should only be empty if the input `json-file` has path to JSON-file
- `json-file` - Path to JSON file. This is ignored if the input `json` is not empty
- `keywords` - **(required)** A set of keywords separated by the SPACE symbol
- `configs-set-jsonpath` - JSON path to the configuration set, where "." is the JSON root, default: _'.'_
- `keywords-set-jsonpath` - JSON path to a set of keys, where "." is the configuration root, default: _'.keywords'_
- `exclude-keywords` - It excludes keywords from the output JSON configurations, default: _true_

### Action outputs

- `config-json` - output configuration array in JSON format
- `matrix` - configurations prepared as a source of strategy
- `length` - contains the number of suitable configurations
- `is-empty` - true if no matching configuration exists
