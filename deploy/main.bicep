param prefix string = 'iivc'

@minValue(1)
@maxValue(5)
@description('DBs sizes in GB')
param dbSize int = 1

@minValue(1)
@maxValue(50)
param dbCount int = 10

param sqlUser string

param sqlPass string

resource sqlServer 'Microsoft.Sql/servers@2014-04-01' ={
  name: '${prefix}-single-db-server'
  location: resourceGroup().location
  properties: {
    administratorLogin: sqlUser
    administratorLoginPassword: sqlPass
  }
}

resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2014-04-01' = [for i in range(0, dbCount):  {
  parent: sqlServer
  name: '${prefix}-single-db-${i}'
  location: resourceGroup().location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    edition: 'Basic'
    maxSizeBytes: string(dbSize * 1024 * 1024 * 1024)
    requestedServiceObjectiveName: 'Basic'
  }
}]
