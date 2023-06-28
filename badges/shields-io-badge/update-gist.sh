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

gistFilename="file.txt"
gistDescription="update"

while [[ "$#" -gt 0 ]]; do
    case $1 in
      -f|--files) files="$2"; shift;;
      -g|--gist-id) gistId="$2"; shift;;
      -t|--gist-auth-token) gistAuthToken="$2"; shift;;
      -d|--gist-description) gistDescription="$2"; shift;;
    esac
    shift
done

payload='{"description":"'$gistDescription'","files":{'$files'}}'

curl -L -X PATCH \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer $gistAuthToken" \
     -H "X-GitHub-Api-Version: 2022-11-28" \
     "https://api.github.com/gists/$gistId" \
     -d "$payload"
