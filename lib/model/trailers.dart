import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Trailers {
  List? result;
  String? statusMessage;
  bool? success;

  Trailers({this.result, this.statusMessage, this.success});

  factory Trailers.create(Map<String, dynamic> trailers) {
    if (trailers["status_message"] == null) {
      return Trailers(success: true, result: trailers["results"]);
    } else {
      return Trailers(
          success: false, statusMessage: trailers["status_message"]);
    }
  }

  static Future<Trailers> getTrailers(int movieId) async {
    Uri url = Uri(
        scheme: "https",
        host: "api.themoviedb.org",
        path: "3/movie/$movieId/videos",
        queryParameters: {
          "api_key": dotenv.env["API_KEY"],
        });

    try {
      var json = await http.get(url);
      var movie = convert.jsonDecode(json.body) as Map<String, dynamic>;

      return Trailers.create(movie);
    } catch (e) {
      throw Exception("cannot get data: ${e.toString()}");
    }
  }
}
