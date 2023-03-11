import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Movies {
  int? page;
  List? result;
  bool? success;
  String? statusMessage;

  Movies({this.result, this.page, this.statusMessage, this.success});

  factory Movies.create(Map<String, dynamic> movie) {
    if (movie["results"] != null) {
      return Movies(
          success: true, result: movie["results"], page: movie["page"]);
    } else {
      return Movies(success: false, statusMessage: movie["status_message"]);
    }
  }

  static Future<Movies> getMovies(String keyword) async {
    Uri url = Uri(
        scheme: "https",
        host: "api.themoviedb.org",
        path: "3/search/movie",
        queryParameters: {
          "api_key": dotenv.env["API_KEY"],
          "query": keyword
        });

    try {
      var json = await http.get(url);
      var movie = convert.jsonDecode(json.body) as Map<String, dynamic>;

      return Movies.create(movie);
    } catch (e) {
      throw Exception("cannot get data: ${e.toString()}");
    }
  }
}
