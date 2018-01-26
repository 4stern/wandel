# wandel

The wandel lib is a migration lib for [dart](https://www.dartlang.org/). The tool itself is not specifically related to databases but basically provides a clean API for running and rolling back tasks. It brings out of the box an MySqlConnector based on [sqljocky5](https://pub.dartlang.org/packages/sqljocky5).

## Installation

Add it to your dependencies
```
dependencies:
  wandel: "^1.0.1"
```

and install the package
```
$ pub get
```

## Usage

Take a look into the example folder.

`pub run example/basic/basic.dart`

```javascript
import 'package:wandel/wandel.dart';

import 'migrations/2018-01-18-task1.dart';
import 'migrations/2018-01-18-task2.dart';
import 'migrations/2018-01-18-task3.dart';

main() async {

    List<WandelMigration> migrations = [
        new MyWandelMigration1(),
        new MyWandelMigration2(),
        new MyWandelMigration3()
    ];

    Wandel wandel = new Wandel(
        migrations: migrations,
        connector: new WandelMySQLConnector(
            tableName       : '__migration',
            user            : 'username',
            password        : 'password',
            database        : 'databasename',
            host            : 'localhost',
            port            : 3306,
            maxConnections  : 5
        )
    );

    wandel.execute(mode: WANDEL_MODE.UP).then((List<WandelMigration> touchedList) {
        print(touchedList);
        print('finished');
    });
}
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Credits

Robert Beyer <4sternrb@googlemail.com>

## License

MIT
