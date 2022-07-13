import 'package:kalawadtimes/pages/loading_2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:kalawadtimes/bloc/bloc.dart';
import 'package:kalawadtimes/constants.dart';
import 'package:kalawadtimes/pages/detail_page.dart';
import 'package:kalawadtimes/pages/home_page.dart';
import 'package:kalawadtimes/pages/loading.dart';
import 'package:kalawadtimes/pages/test.dart';
import 'package:kalawadtimes/services/api.dart';
import 'package:kalawadtimes/services/categories_api.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'bloc/event.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print("OPENED");
  print('background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Chambal Sandesh'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double SECTION_HEIGHT = 50;
  final Bloc _pageBloc = Bloc();
  DeepLinkBloc _bloc = DeepLinkBloc();
  int index = 1;
  Widget func(int i, BuildContext context, double appBar_height) {
    print(i);
    return Container(
        height: MediaQuery.of(context).size.height -
            appBar_height -
            SECTION_HEIGHT -
            20,
        child: Home(index: i));
  }

  Future<String?> initialLink() async {
    try {
      final initialLink = await getInitialLink();
      print(initialLink.toString());
      return initialLink;
    } on PlatformException catch (exception) {
      print(exception.message);
    }
  }

  String deepLinkURL = "";
  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) {
      print("TOKEN: $value");
    });
    messaging.subscribeToTopic("notify");
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
  }

  @override
  void dispose() {
    _pageBloc.dispose();
    PAGENOBLOC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      toolbarTextStyle: TextStyle(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      actionsIconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      title: Center(
        child: Image.asset("assets/logo.png", height: 50),
        //Text("Chambal Sandesh", style: TextStyle(color: Colors.black))
      ),
    );

    return Scaffold(
        appBar: appBar,
        // drawer: Drawer(
        //   child: ListView(
        //     children: [
        //       UserAccountsDrawerHeader(
        //         accountName: Text("Name"),
        //         accountEmail: Text("Email"),
        //       ),
        //       ListTile(title: Text("SETTINGS")),
        //       TextButton(onPressed: () async {}, child: Text("Light mode")),
        //       TextButton(onPressed: () {}, child: Text("Notifications")),
        //       Divider(
        //         height: 10,
        //         thickness: 2,
        //         color: Colors.black,
        //       ),
        //       ListTile(title: Text("LATEST FEATURES")),
        //       TextButton(onPressed: () {}, child: Text("Learn more")),
        //       Divider(
        //         height: 10,
        //         thickness: 2,
        //         color: Colors.black,
        //       ),
        //       TextButton(onPressed: () {}, child: Text("About us")),
        //       TextButton(onPressed: () {}, child: Text("Disclaimer")),
        //     ],
        //   ),
        // ),
        body: Provider<DeepLinkBloc>(
            create: (context) => _bloc,
            dispose: (context, bloc) => bloc.dispose(),
            child: StreamBuilder2<String, int>(
                streams: Tuple2(_bloc.state, _pageBloc.pageStream),
                initialData: Tuple2("null", 1),
                builder: (context, snapshots) {
                  dynamic snapshot = snapshots.item2;

                  if (snapshots.item1.data != null &&
                      Uri.parse(snapshots.item1.data!).queryParameters['p'] !=
                          null) {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Loading_2(
                              id: int.parse(Uri.parse(snapshots.item1.data!)
                                  .queryParameters['p']!)),
                        ),
                      );
                      _bloc.stateSink.add("");
                    });
                  }
                  return ListView(
                    children: [
                      Container(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (var i = 1; i <= 6; i++)
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(90, 40),
                                      elevation: 5,
                                      primary: (i != (snapshot.data as int))
                                          ? buttonColor
                                          : buttonselectColor,
                                    ),
                                    onPressed: () {
                                      index = i;

                                      _pageBloc.eventSink.add(PageChange(i));
                                      PAGENOBLOC.eventSink.add(PageNoChange(1));
                                    },
                                    child: Text("${SECTIONS[i - 1]}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Material(
                                  elevation: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: (index <= 6)
                                            ? buttonColor
                                            : buttonselectColor,
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(5))),

                                    //color: Colors.blue,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        elevation: 5,

                                        alignment: Alignment.center,
                                        hint: Text("जयपुर ग्रामीण",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        disabledHint: Text("जयपुर ग्रामीण"),
                                        //value: index,
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                        ),

                                        style: const TextStyle(
                                            color: Colors.black),
                                        underline: Container(
                                            height: 2, color: Colors.white),
                                        onChanged: (int? newValue) {
                                          print(newValue.toString());
                                          index = newValue!;

                                          _pageBloc.eventSink
                                              .add(PageChange(index));
                                        },
                                        items: <int>[
                                          for (int j = 7; j <= 12; j++) j
                                        ].map<DropdownMenuItem<int>>(
                                            (int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child:
                                                Text("${SECTIONS[value - 1]}"),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Material(
                                  elevation: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: (index <= 6)
                                            ? buttonColor
                                            : buttonselectColor,
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(5))),

                                    //color: Colors.blue,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        elevation: 5,

                                        alignment: Alignment.center,
                                        hint: Text("कृषि",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        disabledHint: Text("कृषि"),
                                        //value: index,
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                        ),

                                        style: const TextStyle(
                                            color: Colors.black),
                                        underline: Container(
                                            height: 2, color: Colors.white),
                                        onChanged: (int? newValue) {
                                          print(newValue.toString());
                                          index = newValue!;

                                          _pageBloc.eventSink
                                              .add(PageChange(index));
                                        },
                                        items: <int>[
                                          for (int j = 13;
                                              j <= SECTIONS.length;
                                              j++)
                                            j
                                        ].map<DropdownMenuItem<int>>(
                                            (int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child:
                                                Text("${SECTIONS[value - 1]}"),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      StreamBuilder(
                          stream: PAGENOBLOC.pageNoStream,
                          initialData: 1,
                          builder: (context, snapshot2) {
                            return Container(
                                height: MediaQuery.of(context).size.height -
                                    appBar.preferredSize.height -
                                    SECTION_HEIGHT -
                                    20,
                                child: Loading(
                                    index: (snapshot.data as int),
                                    page: (snapshot2.data as int))
                                //return (snapshot.data as Widget);
                                //return Test(index: (snapshot.data as int));

                                );
                          }),
                      //func(index,context,appBar.preferredSize.height),
                    ],
                  );
                })));
  }
}
