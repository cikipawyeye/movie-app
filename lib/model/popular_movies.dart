import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PopularMovies {
  bool response;
  String? error;
  List<dynamic>? list;

  PopularMovies(this.response, {this.list, this.error});

  factory PopularMovies.create(http.Response json) {
    var result = convert.jsonDecode(json.body) as Map<String, dynamic>;

    if (json.statusCode == 200) {
      return PopularMovies(true, list: result["results"]);
    } else {
      return PopularMovies(false,
          error: result["status_message"] ??
              "Koneksi ke database gagal! Periksa koneksi internet Anda.");
    }
  }

  static Future<PopularMovies> getPopularMovies() async {
    Uri url = Uri(
        scheme: "https",
        host: "api.themoviedb.org",
        path: "/3/movie/popular",
        queryParameters: {"api_key": dotenv.env["API_KEY"]});
    var json = await http.get(url);
    return PopularMovies.create(json);
  }
}
