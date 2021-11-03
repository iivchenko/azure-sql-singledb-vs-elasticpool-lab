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

var location = resourceGroup().location
resource sqlServer 'Microsoft.Sql/servers@2014-04-01' ={
  name: '${prefix}-single-db-server'
  location: location
  properties: {
    administratorLogin: sqlUser
    administratorLoginPassword: sqlPass
  }
}

resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2014-04-01' = [for i in range(0, dbCount):  {
  parent: sqlServer
  name: '${prefix}-single-db-${i}'
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    edition: 'Basic'
    maxSizeBytes: string(dbSize * 1024 * 1024 * 1024)
    requestedServiceObjectiveName: 'Basic'
  }
}]

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: '${prefix}-single-db-as'
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: 'F1'
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2020-06-01' = [for i in range(0, dbCount): {
  name: '${prefix}-single-db-app-${i}'
  location: location
  dependsOn: [
    sqlServerDatabase
  ]
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|5.0'
      appSettings: [
        {
          name: 'ConnectionStrings__DefaultConnection'
          value: 'Server=${prefix}-single-db-server.database.windows.net,1433;Initial Catalog=${prefix}-single-db-${i};Persist Security Info=False;User ID=${sqlUser};Password=${sqlPass};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
        }
      ]
    }
  }
}]
