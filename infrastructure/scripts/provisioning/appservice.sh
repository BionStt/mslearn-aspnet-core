(
    echo "${newline}${headingStyle}Provisioning Azure App Service Plan...${azCliCommandStyle}"
    set -x
    az appservice plan create \
        --name $appServicePlan \
        --sku F1 \
        --output none
)
(
    echo "${newline}${headingStyle}Provisioning Azure App Service Web App...${azCliCommandStyle}"
    set -x
    az webapp create \
        --name $webAppName \
        --plan $appServicePlan \
        --deployment-local-git \
        --output none
)
(
    echo "${newline}${headingStyle}Configuring local Git deployment to Azure...${azCliCommandStyle}"
    set -x
    az webapp deployment user set \
        --user-name $deploymentUser \
        --password $deploymentPassword \
        --output none
)
(
    echo "${defaultTextStyle}"
    cd $srcWorkingDirectory/$projectRootDirectory 
    set -x
    git init --quiet
    git remote add azure https://$deploymentUser:$deploymentPassword@$webAppName.scm.azurewebsites.net/$webAppName.git
    git checkout -b master
    git add -A
    git commit -am "init"
)