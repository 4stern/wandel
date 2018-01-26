part of wandel;

abstract class WandelMigration {
    WandelConnector connector;

    String get name => this.runtimeType.toString();

    WandelMigration();

    Future<dynamic> up();
    Future<dynamic> down();
}
