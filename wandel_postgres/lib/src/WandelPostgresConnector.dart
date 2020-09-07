part of wandel_postgres;

class WandelPostgresConnector extends WandelConnector {
  final tableName = '__migration';

  final PostgreSQLConnection con;

  WandelPostgresConnector(this.con) : super();

  @override
  Future open() async {
    return _checkMigrationTableOrCreate();
  }

  @override
  Future close({bool forced = false}) async {
    await con.close();
  }

  Future _checkMigrationTableOrCreate() async {
    final sql = '''
      CREATE TABLE IF NOT EXISTS ${tableName}
      (
          name char(254) NOT NULL,
          createtime integer NOT NULL
      )
        ''';
    return con.query(sql);
  }

  @override
  Future<List<String>> getEntries() async {
    final list = <String>[];
    final sql = '''
            SELECT
                name, createtime
            FROM ${tableName}
        ''';
    final results = await con.query(sql);
    await results.forEach((PostgreSQLResultRow row) async {
      final map = row.toColumnMap();
      await list.add(map['name'].toString());
    });
    return list;
  }

  @override
  Future<dynamic> add(WandelMigration migration) async {
    final sql = '''
            INSERT INTO ${tableName}
                (name, createtime)
            VALUES
                (@name, unix_timestamp())
        ''';
    return con.query(sql, substitutionValues: <String, dynamic>{
      'name': migration.name,
    });
  }

  @override
  Future<dynamic> remove(WandelMigration migration) async {
    final sql = '''
            DELETE FROM ${tableName}
            WHERE name = @name
        ''';
    return con.query(sql, substitutionValues: <String, dynamic>{
      'name': migration.name,
    });
  }
}
