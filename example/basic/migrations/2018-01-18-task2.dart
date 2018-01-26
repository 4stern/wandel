import 'package:wandel/wandel.dart';

import 'dart:async';

class MyWandelMigration2 extends WandelMigration {

    MyWandelMigration2() : super();

    @override
    Future<Null> up() async {
        print('up MyWandelMigration2');
        return null;
    }

    @override
    Future<Null> down() async {
        print('down MyWandelMigration2');
        return null;
    }
}
