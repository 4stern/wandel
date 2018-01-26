import 'package:wandel/wandel.dart';

import 'dart:async';

class MyWandelMigration1 extends WandelMigration {

    MyWandelMigration1() : super();

    Future<Null> up() async {
        print('up MyWandelMigration1');
        return null;
    }

    Future<Null> down() async {
        print('down MyWandelMigration1');
        return null;
    }
}
