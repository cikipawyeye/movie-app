import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImdbId {
  String? imdbId;

  ImdbId(this.imdbId);

  factory ImdbId.create(String imdbId) {
    return ImdbId(imdbId);
  }

  static Future<ImdbId> getImdbIdOf(int id) async {
    Uri url = Uri(
        scheme: "https",
        host: "api.themoviedb.org",
        path: "/3/movie/$id",
        queryParameters: {
          "api_key": dotenv.env["API_KEY"],
          "language": "en-US"
        });
    var apiresult = await http.get(url);
    var result = convert.jsonDecode(apiresult.body) as Map<String, dynamic>;

    return ImdbId.create(result["imdb_id"]);
  }
}
