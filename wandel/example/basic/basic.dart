import 'dart:async';

import 'package:sqljocky5/sqljocky.dart';
import 'package:wandel/wandel.dart';
import 'package:wandel_mysql/wandel_mysql.dart';

import 'migrations/2018-01-18-task1.dart';
import 'migrations/2018-01-18-task2.dart';
import 'migrations/2018-01-18-task3.dart';

/// mysql example
Future main() async {
  final migrations = [
    MyWandelMigration1(),
    MyWandelMigration2(),
    MyWandelMigration3(),
  ];

  final connector = WandelMySQLConnector(
    con: await MySqlConnection.connect(
      ConnectionSettings(host: 'local', user: 'me', password: 'sec', db: 'test'),
    ),
  );

  Wandel wandel = Wandel(
    migrations: migrations,
    connector: connector,
  );

  wandel.execute(mode: WANDEL_MODE.UP).then((List<WandelMigration> touchedList) {
    print(touchedList);
    print('finished');
  });
}
