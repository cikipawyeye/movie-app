import 'package:flutter/material.dart';
import 'package:movie_app/model/movies.dart';
import 'package:movie_app/model/popular_movies.dart';
import 'package:movie_app/screen/detail.dart';
import 'package:movie_app/screen/main_screen.dart';

// desktop version
class DesktopVer extends StatefulWidget {
  const DesktopVer({Key? key}) : super(key: key);

  @override
  State<DesktopVer> createState() => _DesktopVerState();
}

class _DesktopVerState extends State<DesktopVer> {
  Movies? _movies;
  PopularMovies? _popularMovies;
  String? _inputSearch;
  String? _searchQuery;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 28),
          child: Row(children: [
            // text
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("MovieDi",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  Text("All about movies.",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 16, fontFamily: "Nunito"))
                ]),
            const Expanded(child: SizedBox()),
            // text field
            Expanded(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onChanged: (String value) {
                        _inputSearch = value;
                      },
                      onSubmitted: (String value) {
                        setState(() {
                          _movies = null;
                          _searchQuery = value;
                        });
                      },
                      decoration: const InputDecoration(
                          labelText: "Search movie",
                          hintText: "Avengers..",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)))),
                    ))),
            // btn search
            ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                    padding: const EdgeInsets.all(3),
                    color: const Color.fromARGB(210, 58, 57, 55),
                    child: IconButton(
                        color: Colors.white,
                        splashColor: Theme.of(context).primaryColor,
                        splashRadius: 250,
                        onPressed: () {
                          setState(() {
                            _movies = null;
                            _searchQuery = _inputSearch;
                          });
                        },
                        icon: const Icon(Icons.search)))),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
          child: Text(
            _searchQuery == "" || _searchQuery == null
                ? "Popular Movies"
                : "Result for `$_searchQuery`",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        // content
        Builder(
          builder: (BuildContext context) {
            if (_searchQuery != null && _searchQuery != "") {
              return searchMovie(_searchQuery!);
            } else {
              return getPopularMovies();
            }
          },
        )
      ],
    );
  }

  // search movies
  Widget searchMovie(String query) {
    if (_movies != null) {
      if (_movies!.success!) {
        return listMovies(_movies!.result!, isFromOmdb: true);
      } else if (_movies!.statusMessage != null) {
        return bgMovieIcon(_movies!.statusMessage!);
      } else {
        return bgMovieIcon(
            "Can`t find movie. Please check your internet connection!");
      }
    } else {
      Movies.getMovies(query).then((value) {
        setState(() {
          _movies = value;
        });
      });
    }

    return bgMovieIcon("Searching for '$query'");
  }

  // get popular movies
  Widget getPopularMovies() {
    if (_popularMovies != null) {
      if (_popularMovies!.list != null) {
        return listMovies(_popularMovies!.list!, isFromOmdb: false);
      } else if (_popularMovies!.error != null) {
        return bgMovieIcon(_popularMovies!.error!);
      }
    } else {
      PopularMovies.getPopularMovies().then((value) {
        setState(() {
          _popularMovies = value;
        });
      });
    }
    return bgMovieIcon("Loading popular movies...");
  }

  // showing list movies
  Widget listMovies(List data, {required bool isFromOmdb}) {
    Size size = MediaQuery.of(context).size;
    double horizontalPadding = 80;
    int gridCount = 2;
    double fontSize = 22;

    if (size.width > 700) {
      fontSize = 26;
    }
    if (size.width > 850) {
      horizontalPadding = 120;
      gridCount = 3;
      fontSize = 20;
    }
    if (size.width > 1000) {
      fontSize = 26;
    }
    if (size.width > 1200) {
      horizontalPadding = 160;
      gridCount = 4;
      fontSize = 22;
    }
    if (size.width > 1500) {
      horizontalPadding = 200;
      gridCount = 5;
      fontSize = 22;
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: GridView.count(
            childAspectRatio: 0.5,
            crossAxisCount: gridCount,
            children: data.map((e) {
              String? imageUrl;
              if (isFromOmdb) {
                if (e["Poster"] != "N/A") {
                  imageUrl = e["Poster"];
                } else {
                  imageUrl =
                      "https://img.icons8.com/ios/344/no-image-gallery.png";
                }
              } else {
                imageUrl = "https://image.tmdb.org/t/p/w500${e["poster_path"]}";
              }
              return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                // card
                return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Detail(e["id"].toString())));
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.black26))),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 8, right: 8, bottom: 20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // poster
                                Container(
                                    constraints: BoxConstraints(
                                        maxHeight:
                                            constraints.maxHeight * 0.71),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.network(imageUrl!,
                                            width: constraints.maxWidth,
                                            height:
                                                constraints.maxHeight * 0.71,
                                            fit: BoxFit.cover))),
                                // title
                                Text(
                                    e[isFromOmdb ? "Title" : "original_title"]
                                                .toString()
                                                .length >
                                            30
                                        ? "${e[isFromOmdb ? "Title" : "original_title"].toString().substring(0, 30)}..."
                                        : e[isFromOmdb
                                                ? "Title"
                                                : "original_title"]
                                            .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize),
                                    textAlign: TextAlign.center),
                                Text(e[isFromOmdb ? "Year" : "release_date"])
                              ])),
                    ));
              });
            }).toList()),
      ),
    );
  }
}
