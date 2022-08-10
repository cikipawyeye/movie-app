// mobile version
import 'package:flutter/material.dart';
import 'package:movie_app/model/movie_list.dart';
import 'package:movie_app/model/popular_movies.dart';
import 'package:movie_app/screen/detail.dart';
import 'package:movie_app/screen/main_screen.dart';

class MobileVer extends StatelessWidget {
  const MobileVer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // all page
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
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
              // content
              const MobileVerContent()
            ]));
  }
}

// content
class MobileVerContent extends StatefulWidget {
  const MobileVerContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MobileVerState();
}

class _MobileVerState extends State<MobileVerContent> {
  String? inputSearch;
  String? query;
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
                                    setState(() {
                                      searchResultMovies = null;
                                      query = value;
                                    });
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
                                      setState(() {
                                        searchResultMovies = null;
                                        query = inputSearch;
                                      });
                                    },
                                    icon: const Icon(Icons.search))))
                      ],
                    ))),
            // text
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Text(
                    query != null && query != ""
                        ? "Result for $query"
                        : "Popular Movies",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold))),
            // Movie
            Builder(builder: (BuildContext context) {
              if (query != null && query != "") {
                return searchMovies(query!);
              } else {
                return getPopularMovies();
              }
            })
          ]),
    );
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

                  // dpi under 320
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
          message = popularMovies!.error ?? "Popular Movies";
        });
      });
    }

    return bgMovieIcon(message);
  }

  Widget searchMovies(String keyword) {
    Size size = MediaQuery.of(context).size;
    String message = "Searching for `$keyword`";

    if (searchResultMovies != null) {
      if (searchResultMovies!.movies != null) {
        return Expanded(
            child: GridView.count(
                childAspectRatio: size.width >= 360 ? 0.5 : 0.7,
                crossAxisCount: 2,
                children: searchResultMovies!.movies!.map((e) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // poster
                                  Container(
                                      constraints: BoxConstraints(
                                          maxHeight:
                                              constraints.maxHeight * 0.71),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(18),
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
      } else if (searchResultMovies!.error != null) {
        message = searchResultMovies!.error!;
      }
    } else {
      Movies.getMovies(keyword).then((value) {
        setState(() {
          searchResultMovies = value;
        });
      });
    }

    return bgMovieIcon(message);
  }
}
