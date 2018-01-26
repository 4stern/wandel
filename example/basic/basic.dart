import 'dart:async';

import 'package:wandel/wandel.dart';

import 'migrations/2018-01-18-task1.dart';
import 'migrations/2018-01-18-task2.dart';
import 'migrations/2018-01-18-task3.dart';

Future main() async {

    List<WandelMigration> migrations = [
        new MyWandelMigration1(),
        new MyWandelMigration2(),
        new MyWandelMigration3()
    ];

    Wandel wandel = new Wandel(
        migrations: migrations,
        connector: new WandelMySQLConnector(
            tableName       : '__migration',
            user            : 'blog',
            password        : 'blog',
            database        : 'blog',
            host            : 'localhost',
            port            : 13381,
            maxConnections  : 5
        )
    );

    wandel.execute(mode: WANDEL_MODE.UP).then((List<WandelMigration> touchedList) {
        print(touchedList);
        print('finished');
    });
}
