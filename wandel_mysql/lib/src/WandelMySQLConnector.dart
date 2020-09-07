part of wandel_mysql;

class WandelMySQLConnector extends WandelConnector {
  String tableName;

  final MySqlConnection con;

  WandelMySQLConnector({this.con, this.tableName: '__migration'}) : super();

  @override
  Future close() async {}

  @override
  Future open() async {
    _checkMigrationTableOrCreate();
  }

  Future _checkMigrationTableOrCreate() async {
    String sql = '''
        CREATE TABLE IF NOT EXISTS ${tableName}
        (
            `name` char(255) NOT NULL,
            `createtime` int(10) unsigned NOT NULL
        )
    ''';
    await con.prepared(sql, <dynamic>[]);
  }

  @override
  Future<List<String>> getEntries() async {
    List<String> list = new List<String>();
    String sql = '''
        SELECT
            `name`, `createtime`
        FROM ${tableName}
    ''';
    Results results = await (await con.prepared(sql, <dynamic>[])).deStream();
    await results.forEach((Row row) async {
      await list.add(row[0].toString());
    });
    return list;
  }

  @override
  Future<dynamic> add(WandelMigration migration) async {
    String sql = '''
        INSERT INTO ${tableName}
            (`name`, `createtime`)
        VALUES
            (?, unix_timestamp())
    ''';
    return con.prepared(sql, <dynamic>[migration.name]);
  }

  @override
  Future<dynamic> remove(WandelMigration migration) async {
    String sql = '''
        DELETE FROM ${tableName}
        WHERE `name` = ?
    ''';
    List<dynamic> parameters = <dynamic>[migration.name];
    return con.prepared(sql, parameters);
  }
}
