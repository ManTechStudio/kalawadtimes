import 'dart:async';

import 'package:kalawadtimes/bloc/event.dart';
import 'package:kalawadtimes/pages/home_page.dart';
import 'package:flutter/services.dart';

import '../pages/test.dart';

class Bloc {
  final _eventController = StreamController<CounterEvent>();
  Stream<CounterEvent> get eventStream => _eventController.stream;
  Sink<CounterEvent> get eventSink => _eventController.sink;

  final _pageController = StreamController<int>();
  Stream<int> get pageStream => _pageController.stream;
  Sink<int> get pageSink => _pageController.sink;

  final _pageNoController = StreamController<int>();
  Stream<int> get pageNoStream => _pageNoController.stream;
  Sink<int> get pageNoSink => _pageNoController.sink;

  Bloc() {
    eventStream.listen((CounterEvent event) {
      /// This call back will be called when new event will be added from sink

      if (event is PageChange) {
        pageSink.add(event.index);
      }
      if (event is PageNoChange) {
        pageNoSink.add(event.page);
      }
    });
  }

  /// call this method to close all the streams
  /// call this method in dispose method of stateful widget
  /// always a good practice to close all the stream at the end
  void dispose() {
    _eventController.close();
    _pageController.close();
  }
}

abstract class Bloc2 {
  void dispose();
}

class DeepLinkBloc extends Bloc2 {
  //Event Channel creation
  static const stream = const EventChannel('http.chambalsandesh.com/events');

  //Method channel creation
  static const platform =
      const MethodChannel('http.chambalsandesh.com/channel');

  StreamController<String> _stateController = StreamController();

  Stream<String> get state => _stateController.stream;

  Sink<String> get stateSink => _stateController.sink;

  //Adding the listener into contructor
  DeepLinkBloc() {
    //Checking application start by deep link
    startUri().then(_onRedirected);
    //Checking broadcast stream, if deep link was clicked in opened appication
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }

  FutureOr<dynamic> _onRedirected(String uri) {
    // Here can be any uri analysis, checking tokens etc, if it’s necessary
    // Throw deep link URI into the BloC's stream
    stateSink.add(uri);
  }

  @override
  void dispose() {
    _stateController.close();
  }

  Future<String> startUri() async {
    try {
      return await platform.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }
}
