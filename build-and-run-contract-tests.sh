#!/bin/bash
#
# This script automates the building and running of contract tests.
# It assumes that build-and-ut.sh has already been run.
#
# Copyright (c) 2023 Open Technologies for Integration
# Licensed under the MIT license (see LICENSE for details)
#

# Exit on any failure
set -e

ibmint deploy --input-path . --output-work-directory $HOME/ace-submodule-subflowlib-level1-work-dir --project SubflowLibLevel1_ContractTest --project SubflowLibLevel1_ScaffoldApp

# ibmint optimize server new for v12.0.4 - speed up test runs
ibmint optimize server --work-directory $HOME/ace-submodule-subflowlib-level1-work-dir --enable JVM --disable NodeJS

# Run the server to run the contract tests
IntegrationServer -w $HOME/ace-submodule-subflowlib-level1-work-dir --test-project SubflowLibLevel1_ContractTest
