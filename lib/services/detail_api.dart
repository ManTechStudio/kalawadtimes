import 'dart:convert';
import 'package:http/http.dart';
import 'package:kalawadtimes/constants.dart';

class DetailAPI {
  Future<Map> getData(int id) async {
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
      Response response, response2;
      response = await get(Uri.parse(
          'https://kalwadtimes.com/index.php?rest_route=/wp/v2/posts/$id'));

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);

        Map m = {};
        m["id"] = data["id"];
        m["title"] = data["title"]["rendered"];
        print("${m["title"]}");
        m["categories"] = data["categories"];
        m["content"] = data["content"]["rendered"];

        try {
          Response response3 = await get(Uri.parse(
              'https://kalwadtimes.com/index.php?rest_route=/wp/v2/media/${data["featured_media"]}'));
          Map m3 = jsonDecode(response3.body);
          m['image'] = m3["guid"]["rendered"];
        } catch (e) {
          m["image"] = "null";
        }
        try {
          if (data["excerpt"]["rendered"] != null)
            m['excerpt'] = data["excerpt"]["rendered"];
        } catch (e) {
          m["excerpt"] = "";
        }

        m["date"] = format(data["date"]);
        m["link"] = data["guid"]["rendered"];
        //m["modified_date"] = data[i]["modified"];

        if (AUTHORS[data["author"]] != null) {
          m['author'] = AUTHORS[data["author"]];
        } else {
          m["author"] = "Unknown";
        }

        return m;
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
    return ({});
  }
}
