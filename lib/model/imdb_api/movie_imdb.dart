import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Movie {
  Map<String, dynamic>? detail;

  Movie(this.detail);

  factory Movie.create(http.Response json) {
    var detailMovie = convert.jsonDecode(json.body) as Map<String, dynamic>;
    return Movie(detailMovie);
  }

  static Future<Movie> getDetailMovie(String imdbID) async {
    Uri url = Uri(
        scheme: "http",
        host: "omdbapi.com",
        queryParameters: {"apikey": dotenv.env["OMDB_API_KEY"], "plot": "full", "i": imdbID});
    var apiresult = await http.get(url);

    return Movie.create(apiresult);
  }
}
