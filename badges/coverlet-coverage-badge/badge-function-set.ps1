################################################################################
#                                                                              #
#   Copyright 2023 Finebits (https://finebits.com)                             #
#                                                                              #
#   Licensed under the Apache License, Version 2.0 (the "License");            #
#   you may not use this file except in compliance with the License.           #
#   You may obtain a copy of the License at                                    #
#                                                                              #
#       http://www.apache.org/licenses/LICENSE-2.0                             #
#                                                                              #
#   Unless required by applicable law or agreed to in writing, software        #
#   distributed under the License is distributed on an "AS IS" BASIS,          #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#   See the License for the specific language governing permissions and        #
#   limitations under the License.                                             #
#                                                                              #
################################################################################


# Converts test coverage to percent.
# The result can contain 2 digits after the decimal point.
function Get-Percent
{
    param
    (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory,ValueFromPipeline)]
        [string] $Rate
    )

    return '{0:0.##}%' -f (($Rate -as [double]) * 100)
}

# Calculates the color of the badge.
# The color can be from red to green.
function Get-BadgeColor
{
    param
    (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory,ValueFromPipeline)]
        [string] $Rate
    )

    $value = $Rate -as [double]

    $color = 0x0000ff

    if (($value -ge 0.5) -and ($value -le 1))
    {
        $red = (2 * 0xff * (1 - $value)) -as [int]
        $color = 0x00ff00 + $red * 0x10000
    }
    elseif (($value -ge 0) -and ($value -le 0.5))
    {
        $green = (2 * 0xff * $value) -as [int]
        $color = 0xff0000 + $green * 0x100
    }

    return '{0:X6}' -f ($color -as [int])
}

# Returns json with 'shields.io' badge information
function Get-BadgeMetadata
{
    [cmdletBinding()]
    param
    (
        # A node of the report xml that contains attributes 'line-rate' (test coverage rate) and 'name' (entity name).
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory=$true, ValueFromPipeline)]
        [object] $Node,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory=$true)]
        [string] $LabelFormat,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory=$false)]
        [string] $OutputFileNameFormat="{0}-test-coverage.json"
    )

    $rate = $Node.Attributes["line-rate"].Value
    $name = $Node.Attributes["name"].Value ?? "total"

    $label = $LabelFormat -f $name
    $file = $OutputFileNameFormat -f $name

    $json = @{ file = $file; label = $label; precent = $rate | Get-Percent; color = $rate | Get-BadgeColor } | ConvertTo-Json -Compress

    return "$json"
}
