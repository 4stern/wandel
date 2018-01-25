part of wandel;

abstract class WandelMigration {
    WandelConnector connector;

    WandelMigration();

    Future<dynamic> up();
    Future<dynamic> down();
}
