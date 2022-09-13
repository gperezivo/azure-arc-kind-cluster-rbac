#!/bin/bash
source ./variables.sh
az logout
az login --use-device-code
az account set --subscription $SUBSCRIPTION_ID --output none
az account show
