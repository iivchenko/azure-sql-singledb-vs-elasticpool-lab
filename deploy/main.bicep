var dbSize = 1 * 1024 * 1024 * 1024
var dbCount = 1

resource sqlServer 'Microsoft.Sql/servers@2014-04-01' ={
  name: 'iivc-single-db-server'
  location: resourceGroup().location
  properties: {
    administratorLogin: 'iivchenko'
    administratorLoginPassword: '123asdQ!'
  }
}

resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2014-04-01' = [for i in range(0, dbCount):  {
  parent: sqlServer
  name: 'iivc-single-db-${i}'
  location: resourceGroup().location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    edition: 'Basic'
    maxSizeBytes: string(dbSize)
    requestedServiceObjectiveName: 'Basic'
  }
}]
