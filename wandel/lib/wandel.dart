/// This library provides migration management and mechanisms
library wandel;

import 'dart:async';

part 'src/WandelConnector.dart';
part 'src/WandelMigration.dart';

enum WANDEL_MODE {
  // load all migrations and execute `up` on all that missing in storage, add also an entry to storage.
  UP,

  // load all migrations and execute `down` on all migrations that already been in the storage, remove also the entry from storage.
  DOWN
}

class Wandel {
  final WandelConnector connector;
  final List<WandelMigration> migrations;

  Wandel({this.connector, this.migrations}) {
    _connectAllMigrations();
  }

  void _connectAllMigrations() {
    migrations.forEach((migration) {
      migration.connector = connector;
    });
  }

  Future<List<WandelMigration>> execute({WANDEL_MODE mode: WANDEL_MODE.UP}) async {
    List<WandelMigration> touchedList;

    await connector.open();
    touchedList = await executeMigrations(mode: mode);
    await end();

    return touchedList;
  }

  Future<dynamic> end() async {
    return connector.close();
  }

  Future<List<WandelMigration>> executeMigrations({WANDEL_MODE mode: WANDEL_MODE.UP}) async {
    switch (mode) {
      case WANDEL_MODE.DOWN:
        return executeDown();

      case WANDEL_MODE.UP:
      default:
        return executeUp();
    }
  }

  Future<List<WandelMigration>> executeUp() async {
    final dbMigrations = await connector.getEntries();
    final iter = migrations.where((WandelMigration migration) => !dbMigrations.contains(migration.name)).iterator;
    final touchedList = <WandelMigration>[];
    while (iter.moveNext()) {
      WandelMigration migration = iter.current;
      await migration.up();
      await connector.add(migration);
      touchedList.add(migration);
    }
    return touchedList;
  }

  Future<List<WandelMigration>> executeDown() async {
    final dbMigrations = await connector.getEntries();
    final iter = migrations.reversed.where((migration) => dbMigrations.contains(migration.name)).iterator;
    final touchedList = <WandelMigration>[];
    while (iter.moveNext()) {
      WandelMigration migration = iter.current;
      await migration.down();
      await connector.remove(migration);
      touchedList.add(migration);
    }
    return touchedList;
  }
}
