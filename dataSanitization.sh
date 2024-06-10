#!/bin/zsh

regAssetTag="CIS123456"

if [[ $regAssetTag =~ "CIS" ]];then
    regAssetTag="$(echo "$regAssetTag" | tr -d CIS )"
fi


echo "$regAssetTag"

