/// This library provides migration management and mechanisms
library wandel;

import 'dart:async';

import 'package:sqljocky5/sqljocky.dart';

part 'src/WandelMigration.dart';
part 'src/WandelConnector.dart';
part 'src/Connectors/WandelMySQLConnector.dart';

enum WANDEL_DIRECTION {
    UP, DOWN
}

class Wandel {

    static final int DIRECTION_UP = 1;
    static final int DIRECTION_DOWN = 1;

    WandelConnector connector;
    List<WandelMigration> migrations;

    Wandel({this.connector, this.migrations}) {
        _connectAllMigrations();
    }

    _connectAllMigrations() {
        migrations.forEach((migration) {
            migration.connector = connector;
        });
    }

    Future<dynamic> execute({WANDEL_DIRECTION direction: WANDEL_DIRECTION.UP}) async {
        return connector.open()
        .then((_) => executeMigrations(direction: direction))
        .then(end);
    }

    Future<dynamic> end(_) async {
        return connector.close();
    }

    Future<dynamic> executeMigrations({WANDEL_DIRECTION direction: WANDEL_DIRECTION.UP}) async {
        switch (direction) {

            case WANDEL_DIRECTION.UP:
                Iterator<WandelMigration> iter = migrations.iterator;
                while(iter.moveNext()) {
                    WandelMigration migration = iter.current;
                    await migration.up();
                }
                break;

            case WANDEL_DIRECTION.DOWN:
                Iterator<WandelMigration> iter = migrations.reversed.iterator;
                while(iter.moveNext()) {
                    WandelMigration migration = iter.current;
                    await migration.down();
                }
                break;
        }
    }

}
