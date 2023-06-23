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

toJsonText() {
    value="${1//\\/\\\\}"
    value="${value//\"/\\\"}"
    echo $value
}

label=""
labelColor="gray"

message='' # Required
color="lightgrey"

isError='false'

namedLogo=''
logoColor=''
logoSvg=''
logoWidth=''
logoPosition=''

style="flat"

gistFilename="badge.json"

while [[ "$#" -gt 0 ]]; do
    case $1 in
      -l|--label) label=$(toJsonText "$2"); shift;;
      -L|--label-color) labelColor="$2"; shift;;

      -m|--message) message=$(toJsonText "$2"); shift;;
      -M|--message-color) color="$2"; shift;;

      -e|--is-error) isError="$2"; shift;;

      -i|--logo) namedLogo=$(toJsonText "$2"); shift;;
      -I|--logo-color) logoColor="$2"; shift;;
      -S|--logo-svg) logoSvg=$(toJsonText "$2"); shift;;
      -w|--logo-width) logoWidth="$2"; shift;;
      -p|--logo-position) logoPosition="$2"; shift;;

      -s|--style) style="$2"; shift;;

      -o|--gist-filename) gistFilename=$(toJsonText "$2"); shift;;
    esac
    shift
done

metadata='{"schemaVersion":1,"label":"'$label'","labelColor":"'$labelColor'","message":"'$message'","color":"'$color'","isError":'$isError',"namedLogo":"'$namedLogo'","logoColor":"'$logoColor'","logoSvg":"'$logoSvg'","logoWidth":"'$logoWidth'","logoPosition":"'$logoPosition'","style":"'$style'"}'
badge=$(echo $metadata | jq -c ' . |  with_entries( select( .value != "" ) )')

badge="${badge//\\/\\\\}"
badge="${badge//\"/\\\"}"

echo '"'$gistFilename'":{"content":"'$badge'"}'
