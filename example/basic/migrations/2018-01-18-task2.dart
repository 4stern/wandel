import 'package:wandel/wandel.dart';

import 'dart:async';

class MyWandelMigration2 extends WandelMigration {

    MyWandelMigration2() : super();

    Future<Null> up() async {
        print('up MyWandelMigration2');
        return null;
    }

    Future<Null> down() async {
        print('down MyWandelMigration2');
        return null;
    }
}
