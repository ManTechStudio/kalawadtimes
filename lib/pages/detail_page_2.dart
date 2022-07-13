import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:html/parser.dart';

import '../constants.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage({Key? key, Map? map})
      : data = map,
        super(key: key);
  Map? data = {};

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Map data;
  void initState() {
    data = widget.data!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_outline)),
              IconButton(
                  onPressed: () {
                    final document = parse(data["excerpt"]);
                    String parsedString =
                        parse(document.body!.text).documentElement!.text;
                    Share.share(
                        " *${data["title"]}* \n \n ${parsedString} \n ${data["link"]}");
                  },
                  icon: Icon(Icons.share)),
            ],
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
            backgroundColor: buttonColor,
            title: Text("Details",
                style: TextStyle(color: Colors.white, fontSize: 20))),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: [
            Center(
                child: Text("${data["title"]}",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            SizedBox(height: 5),
            Text("By ${(data["author"].toString())}"),
            Text("${(data["date"].toString())}"),
            SizedBox(height: 5),
            Container(
                height: MediaQuery.of(context).size.height / 3,
                child: CachedNetworkImage(
                  imageUrl: data["image"],
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
            Html(data: "${data["content"]}"),
            SizedBox(width: 5),
            // Container(
            //     height: 50,
            //     color: Colors.grey,
            //     child: Center(child: Text("NEXT ARTICLE"))),
            // SizedBox(height: 2),
            // (data["index2"] + 1 < data["data"]["list"].length)
            //     ? GestureDetector(
            //   onTap: () {
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //         builder: (BuildContext context) => DetailsPage(map: {
            //           "index1": data["index1"],
            //           "index2": data["index2"] + 1,
            //           "data": data["data"]
            //         }),
            //       ),
            //     );
            //   },
            //   child: Center(
            //       child: Text(
            //           "${data["data"]["list"][data["index2"] + 1]["title"]}",
            //           style: TextStyle(
            //               fontSize: 20, fontWeight: FontWeight.bold))),
            // )
            //     : GestureDetector(
            //   onTap: () {
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //         builder: (BuildContext context) => DetailsPage(map: {
            //           "index1": data["index1"],
            //           "index2": 0,
            //           "data": data["data"]
            //         }),
            //       ),
            //     );
            //   },
            //   child: Center(
            //       child: Text("${data["data"]["list"][0]["title"]}",
            //           style: TextStyle(
            //               fontSize: 20, fontWeight: FontWeight.bold))),
            // ),
            Divider(
              color: Colors.black,
              height: 5,
              thickness: 2,
            )
          ]),
        ));
  }
}
