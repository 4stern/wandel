import 'package:wandel/wandel.dart';

import 'dart:async';

class MyWandelMigration1 extends WandelMigration {

    MyWandelMigration1() : super();

    @override
    Future<Null> up() async {
        print('up MyWandelMigration1');
        return null;
    }

    @override
    Future<Null> down() async {
        print('down MyWandelMigration1');
        return null;
    }
}
