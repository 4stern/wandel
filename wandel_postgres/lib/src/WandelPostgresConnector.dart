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
          name varchar(254) NOT NULL UNIQUE,
          createtime timestamp NOT NULL
      )
    ''';
    return con.query(sql);
  }

  @override
  Future<List<String>> getEntries() async {
    final list = <String>[];
    print(list);
    final sql = '''
      SELECT
          name, createtime
      FROM ${tableName}
    ''';
    final results = await con.query(sql);

    list.addAll(
      results.map((row) => row[0].toString()),
    );

    return list.toList();
  }

  @override
  Future<dynamic> add(WandelMigration migration) async {
    final sql = '''
      INSERT INTO ${tableName}
          (name, createtime)
      VALUES
          (@name, CURRENT_TIMESTAMP)
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
