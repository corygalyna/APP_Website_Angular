#!/bin/sh
# Copyright 2023 (Holloway) Chew, Kean Ho <hollowaykeanho@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at:
#                 http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.




# initialize
if [ "$PROJECT_PATH_ROOT" = "" ]; then
        >&2 printf "[ ERROR ] - Please run from automataCI/ci.sh.ps1 instead!\n"
        return 1
fi

. "${LIBS_AUTOMATACI}/services/io/fs.sh"
. "${LIBS_AUTOMATACI}/services/i18n/translations.sh"
. "${LIBS_AUTOMATACI}/services/compilers/angular.sh"




# execute
__placeholders="\
${PROJECT_SKU}-docs_any-any
"


FS_Remake_Directory "${PROJECT_PATH_ROOT}/${PROJECT_PATH_BUILD}"


I18N_Activate_Environment
ANGULAR_Is_Available
if [ $? -ne 0 ]; then
        I18N_Activate_Failed
        return 1
fi


I18N_Build "$PROJECT_ANGULAR"
__current_path="$PWD" && cd "${PROJECT_PATH_ROOT}/${PROJECT_ANGULAR}"
ANGULAR_Build
___process=$?
cd "$__current_path" && unset __current_path
if [ $___process -ne 0 ]; then
        I18N_Build_Failed
        return 1
fi




___source="${PROJECT_PATH_ROOT}/${PROJECT_ANGULAR}/dist/browser"
___dest="${PROJECT_PATH_ROOT}/${PROJECT_PATH_DOCS}"
I18N_Export "$___dest"
FS_Make_Directory "$___dest"
FS_Copy_All "${___source}/" "$___dest"
if [ $? -ne 0 ]; then
        I18N_Export_Failed
        return 1
fi




# placeholding flag files
old_IFS="$IFS"
while IFS="" read -r __line || [ -n "$__line" ]; do
        if [ $(STRINGS_Is_Empty "$__line") -eq 0 ]; then
                continue
        fi


        # build the file
        __file="${PROJECT_PATH_ROOT}/${PROJECT_PATH_BUILD}/${__line}"
        I18N_Build "$__line"
        FS_Remove_Silently "$__file"
        FS_Touch_File "$__file"
        if [ $? -ne 0 ]; then
                I18N_Build_Failed
                return 1
        fi
done <<EOF
$__placeholders
EOF




# compose documentations




# report status
return 0
