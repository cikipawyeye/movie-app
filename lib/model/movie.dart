import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Movie {
  String? title;
  String? backdropPath;
  int? budget;
  String? genres;
  String? releaseDate;
  String? posterPath;
  String? runtime;
  bool? video;
  String? plot;
  String? imdbResponse;
  String? rated;
  String? imdbRating;
  String? director;
  String? writer;
  String? actor;
  String? language;
  String? country;
  String? awards;
  bool? success;
  String? statusMessage;
  String? imdbError;

  Movie({
    this.title,
    this.backdropPath,
    this.budget,
    this.genres,
    this.releaseDate,
    this.posterPath,
    this.runtime,
    this.video,
    this.plot,
    this.imdbResponse,
    this.rated,
    this.imdbRating,
    this.director,
    this.writer,
    this.actor,
    this.language,
    this.country,
    this.awards,
    this.success,
    this.statusMessage,
    this.imdbError,
  });

  // void test() {
  //   print(title);
  //   print(backdropPath);
  //   print(budget);
  //   print(genres.toString());
  //   print(releaseDate);
  //   print(posterPath);
  //   print(runtime);
  //   print(video);
  //   print(plot);
  //   print(imdbResponse);
  //   print(rated);
  //   print(imdbRating);
  //   print(director);
  //   print(writer);
  //   print(actor);
  //   print(success);
  // }

  factory Movie.create(Map<String, dynamic> movie) {
    return Movie(
        title: movie["original_title"],
        backdropPath:
            "https://image.tmdb.org/t/p/original${movie["backdrop_path"]}",
        budget: movie["budget"],
        genres: movie["Genre"],
        releaseDate: movie["release_date"],
        posterPath: "https://image.tmdb.org/t/p/w500${movie["poster_path"]}",
        runtime: movie["Runtime"],
        video: movie["video"],
        plot: movie["Plot"],
        imdbResponse: movie["Response"],
        rated: movie["Rated"],
        imdbRating: movie["imdbRating"],
        director: movie["Director"],
        writer: movie["Writer"],
        actor: movie["Actors"],
        language: movie["Language"],
        awards: movie["Awards"],
        success: movie["success"],
        statusMessage: movie["status_message"],
        country: movie["Country"],
        imdbError: movie["Error"]);
  }

  static Future<Movie> getMovie(int movieId) async {
    try {
      // detail
      Uri detailUrl = Uri(
          scheme: "https",
          host: "api.themoviedb.org",
          path: "3/movie/$movieId",
          queryParameters: {
            "api_key": dotenv.env["API_KEY"],
            "language": "en-US"
          });
      var jsonDetail = await http.get(detailUrl);
      var movieDetail =
          convert.jsonDecode(jsonDetail.body) as Map<String, dynamic>;

      // imdb
      Uri imdbUrl = Uri(scheme: "http", host: "omdbapi.com", queryParameters: {
        "apikey": dotenv.env["OMDB_API_KEY"],
        "plot": "full",
        "i": movieDetail["imdb_id"]
      });
      var jsonImdb = await http.get(imdbUrl);
      var movieImdb = convert.jsonDecode(jsonImdb.body) as Map<String, dynamic>;

      // merge
      movieDetail.addAll(movieImdb);

      // print(movieDetail);

      return Movie.create(movieDetail);
    } catch (e) {
      throw Exception("cannot get movie data: $e");
    }
  }
}
