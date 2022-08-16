import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

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
          "api_key": "895a3679182cf60867e35b87676b9257",
          "language": "en-US"
        });
    var apiresult = await http.get(url);
    var result = convert.jsonDecode(apiresult.body) as Map<String, dynamic>;

    return ImdbId.create(result["imdb_id"]);
  }
}
