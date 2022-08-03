import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Movies {
  List<dynamic>? movies;
  String? response;
  String? error;

  Movies({this.movies, this.response, this.error});

  factory Movies.list(Map<String, dynamic> object) {
    return Movies(
        movies: object["Search"],
        response: object["Response"],
        error: object["Error"]);
  }

  static Future<Movies> getMovies(String? keyword) async {
    Uri url = Uri(
        scheme: "http",
        host: "omdbapi.com",
        queryParameters: {"apikey": "8dba5781", "s": keyword});

    var apiresult = await http.get(url);
    var jsonObject = convert.jsonDecode(apiresult.body) as Map<String, dynamic>;
    if (apiresult.statusCode == 200) {
      return Movies.list(jsonObject);
    } else {
      return Movies(
          error: "Koneksi ke database gagal! from class Movies.",
          response: "gagal_connect");
    }
  }
}
