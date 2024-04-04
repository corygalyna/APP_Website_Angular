#!/bin/sh
# Copyright 2023  (Holloway) Chew, Kean Ho <hollowaykeanho@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at:
#                http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
. "${LIBS_AUTOMATACI}/services/io/os.sh"
. "${LIBS_AUTOMATACI}/services/io/strings.sh"




AR_Is_Available() {
        # execute
        OS_Is_Command_Available "ar"
        if [ $? -ne 0 ]; then
                return 1
        fi


        # report status
        return 0
}




AR_Create() {
        #___name="$1"
        #___list="$2"


        # validate input
        if [ $(STRINGS_Is_Empty "$1") -eq 0 ] ||
                [ $(STRINGS_Is_Empty "$2") -eq 0 ]; then
                return 1
        fi

        AR_Is_Available
        if [ $? -ne 0 ]; then
                return 1
        fi


        # execute
        ar cr "$1" $2
        if [ $? -ne 0 ]; then
                return 1
        fi


        # report status
        return 0
}
