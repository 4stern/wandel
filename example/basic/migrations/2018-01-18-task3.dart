import 'package:wandel/wandel.dart';

import 'dart:async';

class MyWandelMigration3 extends WandelMigration {

    MyWandelMigration3() : super();

    Future<Null> up() async {
        print('up MyWandelMigration3');
        return null;
    }

    Future<Null> down() async {
        print('down MyWandelMigration3');
        return null;
    }
}
