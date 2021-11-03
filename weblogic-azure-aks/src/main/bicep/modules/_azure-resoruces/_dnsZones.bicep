@description('Azure DNS Zone name.')
param dnszoneName string

resource dnszoneName_resource 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: dnszoneName
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}
