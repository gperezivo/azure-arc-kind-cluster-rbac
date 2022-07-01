#!/bin/bash
source ./variables.sh
az logout
az login 
az account set --subscription $SUBSCRIPTION_ID --output none
az account show
