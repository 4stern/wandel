part of wandel;

class WandelMySQLConnector extends WandelConnector {

    String tableName;
    String database;
    String host;
    int port;
    String user;
    String password;
    int maxConnections;

    ConnectionPool pool;

    WandelMySQLConnector({
        this.tableName: '__migration',
        this.maxConnections: 5,
        this.port: 3306,
        this.database,
        this.host,
        this.user,
        this.password
    }) : super();

    @override
    Future open() async {
        if (pool == null) {
            pool = new ConnectionPool(
                host: this.host,
                port: this.port,
                user: this.user,
                password: this.password,
                db: this.database,
                max: this.maxConnections
            );

            await pool.ping()
            .then(_checkMigrationTableOrCreate)
            .then((_) {

            });
        }
    }

    @override
    Future close({bool forced : false}) async {
        if (forced) {
            pool.closeConnectionsNow();
        } else {
            pool.closeConnectionsWhenNotInUse();
        }
    }

    Future _checkMigrationTableOrCreate(_) async {
        String sql = '''
            CREATE TABLE IF NOT EXISTS __migration
            (
                `name` char(255) NOT NULL,
                `createtime` int(10) unsigned NOT NULL
            )
        ''';
        return pool.prepareExecute(sql, []);
    }

    @override
    Future<List<String>> getEntries() async {
        List<String> list = new List<String>();
        String sql = '''
            SELECT
                `name`, `createtime`
            FROM __migration
        ''';
        await pool.prepareExecute(sql, []).then((Results results) async {
            await results.forEach((Row row) async {
                await list.add(row[0].toString());
            });
        });
        return list;
    }

    @override
    Future<dynamic> add(WandelMigration migration) async {
        String sql = '''
            INSERT INTO __migration
                (`name`, `createtime`)
            VALUES
                (?, NOW())
        ''';
        return pool.prepareExecute(sql, [
            migration.name
        ]);
    }

    @override
    Future<dynamic> remove(WandelMigration migration) async {
        String sql = '''
            DELETE FROM __migration
            WHERE `name` = ?
        ''';
        List<dynamic> parameters = [
            migration.name
        ];
        return pool.prepareExecute(sql, parameters);
    }
}
