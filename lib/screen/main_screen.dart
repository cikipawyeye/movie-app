import 'package:flutter/material.dart';
import 'package:movie_app/model/movie_list.dart';
import 'package:movie_app/model/popular_movies.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
class MobileVer extends StatefulWidget {
  const MobileVer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MobileVerState();
}

class _MobileVerState extends State<MobileVer> {
  String? inputSearch;
  Movies? searchResultMovies;
  PopularMovies? popularMovies;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
            // all page
            mainAxisSize: MainAxisSize.min,
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
                                        hintText: "Search movie..",
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
            ]));
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

    PopularMovies.getPopularMovies().then((value) {
      popularMovies = value;
      message = popularMovies!.error != null
          ? popularMovies!.error!
          : "Popular Movies";
    });

    if (popularMovies != null && popularMovies!.list != null) {
      // list movies
      return Expanded(
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                String url =
                    "https://image.tmdb.org/t/p/w500/${popularMovies!.list![index]["backdrop_path"]}";
                return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    constraints: const BoxConstraints(maxHeight: 90),
                    child: Row(children: [
                      // image
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(url, fit: BoxFit.cover)),
                      const SizedBox(width: 10),
                      // detail
                      Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                            Text(popularMovies!.list![index]["original_title"],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                                "${popularMovies!.list![index]["vote_average"]} vote",
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic))
                          ]))
                    ]));
              },
              itemCount: popularMovies!.list!.length));
    }

    return movieIcon(message);
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
                  return Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 8, right: 8, bottom: 20),
                      child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Container(
                                constraints: BoxConstraints(
                                    maxHeight: constraints.maxHeight * 0.71),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.network(e["Poster"],
                                        width: constraints.maxWidth,
                                        height: constraints.maxHeight * 0.71,
                                        fit: BoxFit.cover))),
                            Text(
                                e["Title"].toString().length > 33
                                    ? "${e["Title"].toString().substring(0, 33)}..."
                                    : e["Title"].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.center),
                            Text(e["Year"])
                          ])));
                });
              }).toList()));
    } else if (list.error != null) {
      message = list.error!;
    }

    return movieIcon(message);
  }

  Widget movieIcon(String message, {IconData? iconParam}) {
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
