// Copyright (c) 2021, Oracle Corporation and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

@description('Secret name of certificate data.')
param certificateDataName string

@description('Certificate data to store in the secret')
param certificateDataValue string

@description('Secret name of certificate password.')
param certificatePswSecretName string

@secure()
@description('Certificate password to store in the secret')
param certificatePasswordValue string

@description('Property to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault.')
param enabledForTemplateDeployment bool = true

@description('Name of the vault')
param keyVaultName string

param location string

@description('Price tier for Key Vault.')
param sku string

param utcValue string = utcNow()

resource keyvault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForTemplateDeployment: enabledForTemplateDeployment
    sku: {
      name: sku
      family: 'A'
    }
    tenantId: subscription().tenantId
  }
  tags:{
    'managed-by-azure-weblogic': utcValue
  }
}

resource secretForCertificate 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: '${keyVaultName}/${certificateDataName}'
  properties: {
    value: certificateDataValue
  }
  dependsOn: [
    keyvault
  ]
}

resource secretForCertPassword 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: '${keyVaultName}/${certificatePswSecretName}'
  properties: {
    value: certificatePasswordValue
  }
  dependsOn: [
    keyvault
  ]
}

output keyVaultName string = keyVaultName
output sslCertDataSecretName string = certificateDataName
output sslCertPwdSecretName string = certificatePswSecretName
