part of wandel_mysql;

abstract class MySQLWandelMigration extends WandelMigration {
  MySQLWandelMigration() : super();

  MySqlConnection get connection => (connector as WandelMySQLConnector).con;
}
