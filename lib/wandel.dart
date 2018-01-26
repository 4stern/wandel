/// This library provides migration management and mechanisms
library wandel;

import 'dart:async';

import 'package:sqljocky5/sqljocky.dart';

part 'src/WandelMigration.dart';
part 'src/WandelConnector.dart';
part 'src/Connectors/WandelMySQLConnector.dart';

enum WANDEL_MODE {

    // load all migrations and execute `up` on all that missing in storage, add also an entry to storage.
    UP,

    // load all migrations and execute `down` on all migrations that already been in the storage, remove also the entry from storage.
    DOWN
}

class Wandel {
    WandelConnector connector;
    List<WandelMigration> migrations;

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
        return connector.open()
        .then((_) async => touchedList = await executeMigrations(mode: mode))
        .then(end)
        .then((_) {
            return touchedList;
        });
    }

    Future<dynamic> end(_) async {
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
        List<String> dbMigrations = await connector.getEntries();
        Function migrationsNotInStorage = (migration) => !dbMigrations.contains(migration.name);
        Iterator<WandelMigration> iter = migrations.where(migrationsNotInStorage).iterator;
        List<WandelMigration> touchedList = new List<WandelMigration>();
        while(iter.moveNext()) {
            WandelMigration migration = iter.current;
            await migration.up();
            await connector.add(migration);
            touchedList.add(migration);
        }
        return touchedList;
    }

    Future<List<WandelMigration>> executeDown() async {
        List<String> dbMigrations = await connector.getEntries();
        Function migrationsInStorage = (migration) => dbMigrations.contains(migration.name);
        Iterator<WandelMigration> iter = migrations.reversed.where(migrationsInStorage).iterator;
        List<WandelMigration> touchedList = new List<WandelMigration>();
        while(iter.moveNext()) {
            WandelMigration migration = iter.current;
            await migration.down();
            await connector.remove(migration);
            touchedList.add(migration);
        }
        return touchedList;
    }

}
