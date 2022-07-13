import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:kalawadtimes/constants.dart';

class API {
  Future<Map> getData(int index, int cpage) async {
    String format(String date) {
      List<String> months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      String s1 = date.substring(0, 10);
      String year = date.substring(0, 4);
      String month = months[int.parse(date.substring(5, 7)) - 1];
      String day = date.substring(8, 10);
      return "${day} ${month}, ${year} at ${date.substring(11)} IST";
    }

    try {
      // var request = Request('GET', Uri.parse('http://chambalsandesh.com/cs/wp-json/wp/v2/posts/'));
      Response response, response2;
      (index == 1)
          ? response = await get(Uri.parse(
              'https://kalwadtimes.com/index.php?rest_route=/wp/v2/posts/'))
          : response = await get(Uri.parse(
              'https://kalwadtimes.com/index.php?rest_route=/wp/v2/posts&&ategories=${S1[SECTIONS[index - 1]]}&&page=$cpage'));
      int page = 1;
      if (response.statusCode == 200) {
        List l = [];
        List data = jsonDecode(response.body);
        if (index != 1) {
          print("${S1[SECTIONS[index - 1]]}");
          Response response2 = await get(Uri.parse(
              'https://kalwadtimes.com/index.php?rest_route=/wp/v2/categories/${S1[SECTIONS[index - 1]]}'));
          Map m1 = jsonDecode(response2.body);
          print(m1.toString());
          page = ((m1["count"]) / 10).toInt() + 1;
        }
        int ii = 0;
        (index == 1) ? ii = 0 : ii = 0;
        for (int i = ii; i < data.length; i++) {
          Map m = {};
          m["id"] = data[i]["id"];
          m["title"] = data[i]["title"]["rendered"];
          print("${m["title"]}");
          m["categories"] = data[i]["categories"];
          m["content"] = data[i]["content"]["rendered"];
          //final regexp = RegExp(r'(?<=content=).*');
          //r'/(?<=image\\\" content=\\\").*(?=\\\" \/>\\n\\t<meta property=\\\"og:image:wid)');
          // final match = regexp.firstMatch(data[i]["yoast_head"]);
          // print(regexp.hasMatch(data[i]["yoast_head"]));
          //print(match);
          try {
            // final regexp = RegExp(
            //     '(?<=image\" content=\").*(?=\" />\n\t<meta property=\"og:image:wid)');
            Response response3 = await get(Uri.parse(
                'https://kalwadtimes.com/index.php?rest_route=/wp/v2/media/${data[i]["featured_media"]}'));
            Map m3 = jsonDecode(response3.body);
            m['image'] = m3["guid"]["rendered"];
          } catch (e) {
            m["image"] = "null";
          }
          try {
            if (data[i]["excerpt"]["rendered"] != null)
              m['excerpt'] = data[i]["excerpt"]["rendered"];
          } catch (e) {
            m["excerpt"] = "";
          }

          m["date"] = format(data[i]["date"]);
          m["link"] = data[i]["guid"]["rendered"];
          //m["modified_date"] = data[i]["modified"];

          if (AUTHORS[data[i]["author"]] != null) {
            m['author'] = AUTHORS[data[i]["author"]];
          } else {
            m["author"] = "Unknown";
          }
          l.add(m);
        }

        //debugPrint(data[1]["yoast_head"]);
        return {"list": l, "pages": page, "cpage": cpage};
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
    return ({});
  }
}
