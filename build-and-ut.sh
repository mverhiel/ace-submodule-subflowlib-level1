#!/bin/bash
#
# This script automates the building and testing of the shared library.
#
# Copyright (c) 2023 Open Technologies for Integration
# Licensed under the MIT license (see LICENSE for details)
#

# Exit on any failure
set -e

# Move submodule projects to the correct level to be picked up by ibmint
find ace* -name ".project" -exec dirname {} ";" | xargs -n1 -i{} echo cp -rf {} .  | grep -v Test | grep -v Scaffold >> $HOME/move-projects.sh || /bin/true
cat $HOME/move-projects.sh
chmod 777 $HOME/move-projects.sh
bash $HOME/move-projects.sh

# Create the work directory
rm -rf $HOME/ace-submodule-subflowlib-level1-work-dir
mqsicreateworkdir $HOME/ace-submodule-subflowlib-level1-work-dir

ibmint deploy --input-path . --output-work-directory $HOME/ace-submodule-subflowlib-level1-work-dir --project SubflowLibLevel1 --project SubflowLibLevel1_ScaffoldApp --project SubflowLibLevel1_UnitTest --project JavaLibLevel1

# ibmint optimize server new for v12.0.4 - speed up test runs
ibmint optimize server --work-directory $HOME/ace-submodule-subflowlib-level1-work-dir --enable JVM --disable NodeJS

# Run the server to run the unit tests
IntegrationServer -w $HOME/ace-submodule-subflowlib-level1-work-dir --test-project SubflowLibLevel1_UnitTest
