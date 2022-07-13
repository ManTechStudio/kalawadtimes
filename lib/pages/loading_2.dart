import 'package:kalawadtimes/pages/detail_page_2.dart';
import 'package:kalawadtimes/services/detail_api.dart';
import 'package:flutter/material.dart';
import 'package:kalawadtimes/pages/home_page.dart';
import 'package:kalawadtimes/services/api.dart';

class Loading_2 extends StatelessWidget {
  Loading_2({Key? key, int? id})
      : i = id,
        super(key: key);
  int? i = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DetailAPI().getData(i!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
            );
          } else {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    'Something went wrong, try again.',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              );
            } else {
              return ((snapshot.data as Map).isNotEmpty)
                  ? Scaffold(
                      //appBar: AppBar(title: Text("Details"),),
                      body: //Text("${snapshot.data as Map}"),
                          DetailsPage(map: snapshot.data as Map),
                    )
                  : Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                      ),
                      body: Text("Not found"),
                    );
            }
          }
        });
  }
}
