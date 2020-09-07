part of wandel;

abstract class WandelMigration {
    WandelConnector connector;

    WandelMigration();

    String get name => this.runtimeType.toString();

    Future<dynamic> up();
    Future<dynamic> down();
}
