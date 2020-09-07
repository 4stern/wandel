part of wandel_postgres;

abstract class PostgresWandelMigration extends WandelMigration {
  PostgresWandelMigration() : super();

  PostgreSQLConnection get connection => (connector as WandelPostgresConnector).con;
}
