import 'package:wandel/wandel.dart';

import 'migrations/2018-01-18-task1.dart';

main() async {

    List<WandelMigration> migrations = [
        new MyWandelMigration1()
    ];

    Wandel wandel = new Wandel(
        connector: new WandelMySQLConnector(
            tableName       : '__migration',
            user            : 'blog',
            password        : 'blog',
            database        : 'blog',
            host            : 'localhost',
            port            : 13381,
            maxConnections  : 5
        ),
        migrations: migrations
    );

    wandel.execute(direction: WANDEL_DIRECTION.UP).then((_) {
        print('finished');
    });
}
