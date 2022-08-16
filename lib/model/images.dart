import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Images {
  List? backdrops;
  List? posters;
  String? statusMessage;
  bool? success;

  Images({this.backdrops, this.posters, this.statusMessage, this.success});

  factory Images.create(Map<String, dynamic> movie) {
    if (movie["status_message"] == null) {
      return Images(
          success: true,
          backdrops: movie["backdrops"],
          posters: movie["posters"]);
    } else {
      return Images(success: false, statusMessage: movie["status_message"]);
    }
  }

  static Future<Images> getImages(int id) async {
    Uri url = Uri(
        scheme: "https",
        host: "api.themoviedb.org",
        path: "3/movie/$id/images",
        queryParameters: {
          "api_key": "895a3679182cf60867e35b87676b9257",
        });

    try {
      var json = await http.get(url);
      var movie = convert.jsonDecode(json.body) as Map<String, dynamic>;

      return Images.create(movie);
    } catch (e) {
      throw Exception("cannot get data: ${e.toString()}");
    }
  }
}
