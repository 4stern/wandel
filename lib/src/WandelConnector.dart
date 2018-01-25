part of wandel;

abstract class WandelConnector {

    WandelConnector();

    Future<dynamic> open() async {}
    Future<dynamic> close() async {}
}
