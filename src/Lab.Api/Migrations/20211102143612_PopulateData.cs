using Microsoft.EntityFrameworkCore.Migrations;

namespace Lab.Api.Migrations
{
    public partial class PopulateData : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            var sql = @"
                DECLARE @Count INT = 100000;

                WHILE @Count > 0
                BEGIN
                   INSERT INTO [dbo].[Posts] ([Id]) VALUES (NEWID())
                   SET @Count = @Count - 1;
                END;
            ";

            migrationBuilder.Sql(sql);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
