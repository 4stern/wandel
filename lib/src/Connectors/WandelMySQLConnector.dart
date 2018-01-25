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
    }) : super() {

    }

    Future open() async {
        pool = new ConnectionPool(
            host: this.host,
            port: this.port,
            user: this.user,
            password: this.password,
            db: this.database,
            max: this.maxConnections
        );

        return pool.ping()
        .then(_checkMigrationTableOrCreate)
        .then((_) {

        });
    }

    Future close({bool forced : false}) async {
        if (forced) {
            pool.closeConnectionsNow();
        } else {
            pool.closeConnectionsWhenNotInUse();
        }
    }

    Future _checkMigrationTableOrCreate(_) async {

    }
}
