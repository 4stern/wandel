part of wandel;

abstract class WandelConnector {

    WandelConnector();

    Future<dynamic> open();
    Future<dynamic> close();
    Future<List<String>> getEntries();
    Future<dynamic> add(WandelMigration migration);
    Future<dynamic> remove(WandelMigration migration);
}
