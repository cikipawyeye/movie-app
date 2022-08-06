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
        return const MobileVer();
      }),
    ])));
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
      child: Column(
          // all page
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
                                              Radius.circular(20.0)))),
                                ))),
                        // btn search
                        CircleAvatar(
                            radius: 25,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: IconButton(
                                color: Colors.white,
                                splashColor: Theme.of(context).primaryColor,
                                splashRadius: 250,
                                onPressed: () {
                                  print(inputSearch);
                                  searchAction(inputSearch);
                                  inputSearch = null;
                                },
                                icon: const Icon(Icons.search)))
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
                return searchMovies(searchResultMovies!);
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
    String message = "Popular";

    // waiting data
    PopularMovies.getPopularMovies().then((value) {
      setState(() {
        popularMovies = value;
        message = popularMovies!.error != null
            ? popularMovies!.error!
            : "Popular Movies";
      });
    });

    if (popularMovies != null && popularMovies!.list != null) {
      // list movies
      return Expanded(
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                String imageUrl =
                    "https://image.tmdb.org/t/p/w500/${popularMovies!.list![index]["backdrop_path"]}";

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
                            child: Image.network(imageUrl, fit: BoxFit.cover)),
                        const SizedBox(width: 10),
                        // detail
                        Expanded(
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                              Text(
                                  popularMovies!.list![index]["original_title"],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  "${popularMovies!.list![index]["vote_average"]}/10 vote",
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic))
                            ]))
                      ])),
                );
              },
              itemCount: popularMovies!.list!.length));
    }

    return bgMovieIcon(message);
  }

  Widget searchMovies(Movies list) {
    String message = "Cari Film";
    if (list.movies != null) {
      return Expanded(
          child: GridView.count(
              childAspectRatio: 0.5,
              crossAxisCount: 2,
              children: list.movies!.map((e) {
                return LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Detail(e["imdbID"])));
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 8, right: 8, bottom: 20),
                          child: Container(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
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
                                Text(
                                    e["Title"].toString().length > 33
                                        ? "${e["Title"].toString().substring(0, 33)}..."
                                        : e["Title"].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    textAlign: TextAlign.center),
                                Text(e["Year"])
                              ]))));
                });
              }).toList()));
    } else if (list.error != null) {
      message = list.error!;
    }

    return bgMovieIcon(message);
  }

  Widget bgMovieIcon(String message, {IconData? iconParam}) {
    IconData icon = Icons.movie_filter;
    if (iconParam != null) {
      icon = iconParam;
    }
    return Expanded(
        child: Container(
            margin: const EdgeInsets.only(top: 0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 70, color: Colors.black38),
              const SizedBox(height: 10),
              Text(message)
            ])));
  }
}
