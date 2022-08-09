import 'package:flutter/material.dart';
import 'package:movie_app/model/movie_list.dart';
import 'package:movie_app/model/popular_movies.dart';
import 'package:movie_app/screen/detail.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/background/margo2.jpg")))),
      LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double width = MediaQuery.of(context).size.width;
        // check desktop ver or mobile ver
        if (width < 600) {
          return const MobileVer();
        }
        return const DesktopVer();
      }),
    ])));
  }
}

class DesktopVer extends StatefulWidget {
  const DesktopVer({Key? key}) : super(key: key);

  @override
  State<DesktopVer> createState() => _DesktopVerState();
}

class _DesktopVerState extends State<DesktopVer> {
  Movies? movies;
  PopularMovies? popularMovies;
  String? inputSearch;
  String? searchQuery;

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
                        inputSearch = value;
                      },
                      onSubmitted: (String value) {
                        setState(() {
                          searchQuery = value;
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
                          print(inputSearch);
                          setState(() {
                            searchQuery = inputSearch;
                          });
                        },
                        icon: const Icon(Icons.search)))),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
          child: Text(
            searchQuery == "" || searchQuery == null
                ? "Popular Movies"
                : "Result for $searchQuery",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        // content
        Builder(
          builder: (BuildContext context) {
            if (searchQuery != null && searchQuery != "") {
              return searchMovie(searchQuery!);
            } else {
              movies = null;
              return getPopularMovies();
            }
          },
        )
      ],
    );
  }

  Widget searchMovie(String query) {
    Movies.getMovies(query).then((value) {
      setState(() {
        movies = value;
      });
    });

    if (movies != null) {
      if (movies!.response == "True") {
        return listMovies(movies!.movies!, true);
      } else if (movies!.error != null) {
        return bgMovieIcon(movies!.error!);
      } else {
        return bgMovieIcon(
            "Can`t find movie. Please check your internet connection!");
      }
    }

    return bgMovieIcon("Searching for '$query'");
  }

  Widget getPopularMovies() {
    if (popularMovies != null) {
      if (popularMovies!.list != null) {
        return listMovies(popularMovies!.list!, false);
      } else if (popularMovies!.error != null) {
        return bgMovieIcon(popularMovies!.error!);
      }
    } else {
      PopularMovies.getPopularMovies().then((value) {
        setState(() {
          popularMovies = value;
        });
      });
    }
    return bgMovieIcon("Loading popular movies...");
  }

  Widget listMovies(List data, bool isFromOmdb) {
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
                          builder: (context) => Detail(
                              e[isFromOmdb ? "imdbID" : "id"].toString(),
                              isImdbId: isFromOmdb)));
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

// mobile version
class MobileVer extends StatelessWidget {
  const MobileVer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
            // all page
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // text
              SizedBox(
                  height: 100,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("MovieDi",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold)),
                            Text("All about movies.",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 16, fontFamily: "Nunito"))
                          ]))),
              const MobileVerContent()
            ]));
  }
}

class MobileVerContent extends StatefulWidget {
  const MobileVerContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MobileVerState();
}

class _MobileVerState extends State<MobileVerContent> {
  String? inputSearch;
  Movies? searchResultMovies;
  PopularMovies? popularMovies;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // all page
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // search bar
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                child: Container(
                    constraints: const BoxConstraints(maxHeight: 42),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // text field
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: TextField(
                                  onChanged: (String value) {
                                    inputSearch = value;
                                  },
                                  onSubmitted: (String value) {
                                    searchAction(value);
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Search movie",
                                      hintText: "Avengers..",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 20),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)))),
                                ))),
                        // btn search
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                                color: const Color.fromARGB(210, 58, 57, 55),
                                child: IconButton(
                                    color: Colors.white,
                                    splashColor: Theme.of(context).primaryColor,
                                    splashRadius: 250,
                                    onPressed: () {
                                      print(inputSearch);
                                      searchAction(inputSearch);
                                    },
                                    icon: const Icon(Icons.search))))
                      ],
                    ))),
            // text
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Text(
                    searchResultMovies != null
                        ? "Result for $inputSearch"
                        : "Popular Movies",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold))),
            // Movie
            Builder(builder: (BuildContext context) {
              if (searchResultMovies != null) {
                return showSearchMovies(searchResultMovies!);
              } else {
                return getPopularMovies();
              }
            })
          ]),
    );
  }

  void searchAction(String? keywordTitle) {
    if (keywordTitle != null && keywordTitle != "") {
      Movies.getMovies(keywordTitle).then((value) {
        setState(() {
          inputSearch = keywordTitle;
          searchResultMovies = value;
        });
      });
    } else {
      setState(() {
        searchResultMovies = null;
      });
    }
  }

  Widget getPopularMovies() {
    String message = "Loading popular movies...";
    Size size = MediaQuery.of(context).size;

    if (popularMovies != null) {
      if (popularMovies!.list != null) {
        // list movies
        return Expanded(
            child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  String imageUrl =
                      "https://image.tmdb.org/t/p/w500/${popularMovies!.list![index]["backdrop_path"]}";

                  if (size.width < 320) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Detail(
                              popularMovies!.list![index]["id"].toString(),
                              isImdbId: false);
                        }));
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: Center(
                              child: Stack(fit: StackFit.expand, children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    Image.network(imageUrl, fit: BoxFit.cover)),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                popularMovies!.list![index]["original_title"],
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            )
                          ]))),
                    );
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Detail(
                            popularMovies!.list![index]["id"].toString(),
                            isImdbId: false);
                      }));
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                        constraints: const BoxConstraints(maxHeight: 90),
                        child: Row(children: [
                          // image
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  Image.network(imageUrl, fit: BoxFit.cover)),
                          const SizedBox(width: 10),
                          // detail
                          Expanded(child: Builder(builder: (context) {
                            if (size.width < 360) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // title
                                    Text(
                                        popularMovies!.list![index]
                                            ["original_title"],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold))
                                  ]);
                            }
                            return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // title
                                  Text(
                                      popularMovies!.list![index]
                                          ["original_title"],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  // vote
                                  Text(
                                      "${popularMovies!.list![index]["vote_average"]}/10 vote",
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic))
                                ]);
                          }))
                        ])),
                  );
                },
                itemCount: popularMovies!.list!.length));
      } else if (popularMovies!.error != null) {
        return bgMovieIcon(popularMovies!.error!);
      }
    } else {
      // waiting data
      PopularMovies.getPopularMovies().then((value) {
        setState(() {
          popularMovies = value;
          message = popularMovies!.error != null
              ? popularMovies!.error!
              : "Popular Movies";
        });
      });
    }

    return bgMovieIcon(message);
  }

  Widget showSearchMovies(Movies list) {
    Size size = MediaQuery.of(context).size;
    String message = "Cari Film";
    if (list.movies != null) {
      return Expanded(
          child: GridView.count(
              childAspectRatio: size.width >= 360 ? 0.5 : 0.7,
              crossAxisCount: 2,
              children: list.movies!.map((e) {
                return LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  if (size.width < 360) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Detail(e["imdbID"])));
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Stack(children: [
                            // poster
                            Container(
                                constraints: BoxConstraints(
                                    maxHeight: constraints.maxHeight),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.network(e["Poster"],
                                        width: constraints.maxWidth,
                                        height: constraints.maxHeight,
                                        fit: BoxFit.cover))),
                            // title
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  e["Title"].toString().length > 33
                                      ? "${e["Title"].toString().substring(0, 33)}..."
                                      : e["Title"].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white)),
                            )
                          ])),
                    );
                  }
                  // card
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Detail(e["imdbID"])));
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 8, right: 8, bottom: 20),
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
                                        child: Image.network(e["Poster"],
                                            width: constraints.maxWidth,
                                            height:
                                                constraints.maxHeight * 0.71,
                                            fit: BoxFit.cover))),
                                // title
                                Text(
                                    e["Title"].toString().length > 33
                                        ? "${e["Title"].toString().substring(0, 33)}..."
                                        : e["Title"].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width > 480 ? 20 : 15),
                                    textAlign: TextAlign.center),
                                Text(e["Year"])
                              ])));
                });
              }).toList()));
    } else if (list.error != null) {
      message = list.error!;
    }

    return bgMovieIcon(message);
  }
}

Widget bgMovieIcon(String message, {IconData? iconParam}) {
  IconData icon = Icons.movie_filter;
  if (iconParam != null) {
    icon = iconParam;
  }
  return Expanded(
      child: Container(
          margin: const EdgeInsets.only(top: 0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 70, color: Colors.black38),
            const SizedBox(height: 10),
            Text(message)
          ])));
}
