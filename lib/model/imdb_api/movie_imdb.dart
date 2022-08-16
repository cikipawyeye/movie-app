import 'dart:convert' as convert;
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
        queryParameters: {"apikey": "8dba5781", "plot": "full", "i": imdbID});
    var apiresult = await http.get(url);

    return Movie.create(apiresult);
  }
}
