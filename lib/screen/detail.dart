import 'package:flutter/material.dart';
import 'package:movie_app/model/get_imdb_id.dart';
import 'package:movie_app/model/movie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Detail extends StatefulWidget {
  final String idMovie;
  final bool? isImdbId;

  const Detail(this.idMovie, {Key? key, this.isImdbId}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Movie? movie;
  List<String>? genre;

  final PanelController _panelController = PanelController();

  void getDetail(String id) {
    Movie.getDetailMovie(id).then((value) {
      setState(() {
        movie = value;
      });
      print(movie!.detail!["Title"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (movie == null) {
      if (widget.isImdbId != null && !widget.isImdbId!) {
        ImdbId.getImdbIdOf(int.parse(widget.idMovie)).then((value) {
          getDetail(value.imdbId!);
        });
      } else {
        getDetail(widget.idMovie);
      }
      return const Scaffold(body: Center(child: Text("Loading data...")));
    }

    genre = movie!.detail!["Genre"].toString().split(", ");

    return content();
  }

  Widget movieAttribute() {
    Size size = MediaQuery.of(context).size;
    double padding = 50;
    double fontSize = 14;
    if (size.width > 700) {
      padding = 5;
      fontSize = 17;
    }
    if (size.width > 1000) {
      padding = 150;
    }
    if (size.width > 1200) {
      padding = 200;
      fontSize = 19;
    }
    if (size.width > 1400) {
      padding = 300;
    }
    if (size.width > 700) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: padding),
        child: Column(
          children: [
            // movie title
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Text(movie!.detail!["Title"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: fontSize + 8, fontWeight: FontWeight.bold))),
            Row(children: [
              // poster
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        constraints:
                            BoxConstraints(maxHeight: size.height * 0.5),
                        child: Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  movie!.detail!["Poster"],
                                  fit: BoxFit.contain,
                                ))),
                      ))),
              Expanded(
                  child: Center(
                      child: Column(children: [
                // rating
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            movie!.detail!["Rated"],
                            style: TextStyle(fontSize: fontSize + 2),
                          ),
                          const SizedBox(width: 40),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 25),
                                Text(
                                  movie!.detail!["imdbRating"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSize + 6),
                                ),
                                Text("/10",
                                    style: TextStyle(fontSize: fontSize - 2)),
                              ])
                        ])),
                // genre
                Builder(builder: (context) {
                  if (genre!.length < 5) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: genre!.map((e) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                                color: Colors.black12,
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Text(e,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: fontSize - 2)),
                                )),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Column(
                      children: genre!.map((e) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                                color: Colors.black12,
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Text(e,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: fontSize - 2)),
                                )),
                          ),
                        );
                      }).toList(),
                    );
                  }
                }),
                // like
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          LikeButton(),
                          SizedBox(width: 22),
                          Icon(Icons.share)
                        ]))
              ])))
            ]),
          ],
        ),
      );
    } else if (size.width < 325) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        // poster
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            constraints: BoxConstraints(maxHeight: size.height * 0.5),
            child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    movie!.detail!["Poster"],
                    fit: BoxFit.contain,
                  )),
            ),
          ),
        ),
        // movie title
        Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 18),
            child: Text(movie!.detail!["Title"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold))),
        // genre
        Column(
          mainAxisSize: MainAxisSize.min,
          children: genre!.map((e) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                    color: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child:
                          Text(e, style: const TextStyle(color: Colors.black)),
                    )),
              ),
            );
          }).toList(),
        ),
        // rating
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                movie!.detail!["Rated"],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 25),
                    Text(
                      movie!.detail!["imdbRating"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Text("/10"),
                  ]),
              const LikeButton(),
              const Icon(Icons.share)
            ]))
      ]);
    } else {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        // poster
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            constraints: BoxConstraints(maxHeight: size.height * 0.5),
            child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    movie!.detail!["Poster"],
                    fit: BoxFit.contain,
                  )),
            ),
          ),
        ),
        // movie title
        Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 18),
            child: Text(movie!.detail!["Title"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold))),
        // genre
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: genre!.map((e) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(e, style: const TextStyle(color: Colors.black)),
                  )),
            );
          }).toList(),
        ),
        // rating
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const LikeButton(),
                  Text(
                    movie!.detail!["Rated"],
                    style: const TextStyle(fontSize: 16),
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 25),
                        Text(
                          movie!.detail!["imdbRating"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Text("/10"),
                      ]),
                  const Icon(Icons.share)
                ]))
      ]);
    }
  }

  Scaffold content() {
    Size size = MediaQuery.of(context).size;
    double padding = 50;
    double fontSize = 14;
    if (size.width > 700) {
      padding = 150;
      fontSize = 17;
    }
    if (size.width > 1000) {
      padding = 200;
    }
    if (size.width > 1200) {
      padding = 300;
      fontSize = 19;
    }
    if (size.width > 1400) {
      padding = 450;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Movie"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(children: [
        Container(
          padding: const EdgeInsets.all(0),
          child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                movieAttribute(),
                Container(
                  color: const Color.fromARGB(31, 189, 189, 189),
                  padding: EdgeInsets.only(
                      left: padding, right: padding, bottom: 80, top: 35),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text("Released",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(movie!.detail!["Released"],
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text("Runtime",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(movie!.detail!["Runtime"],
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text("Director",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(movie!.detail!["Director"],
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text("Writer",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(movie!.detail!["Writer"],
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text("Actors",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(movie!.detail!["Actors"],
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text("Language",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(movie!.detail!["Language"],
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text("Writer",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(movie!.detail!["Writer"],
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text("Country",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(movie!.detail!["Country"],
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text("Awards",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(movie!.detail!["Awards"],
                                    style: TextStyle(fontSize: fontSize))),
                          ])
                    ],
                  ),
                )
              ]),
        ),
        // dragable sliding up
        SlidingUpPanel(
          controller: _panelController,
          borderRadius: radius,
          maxHeight: (size.height * 0.44) - AppBar().preferredSize.height,
          minHeight: size.height * 0.03,
          panelBuilder: (controller) {
            String plot = movie!.detail!["Plot"];
            return SingleChildScrollView(
                controller: controller,
                child: Column(children: [
                  GestureDetector(
                    onTap: () {
                      _panelController.isPanelOpen
                          ? _panelController.close()
                          : _panelController.open();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 25,
                      height: 5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 40),
                      child: Text(
                        plot,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: fontSize),
                      ))
                ]));
          },
        )
      ]),
    );
  }

  BorderRadius radius = const BorderRadius.only(
      topLeft: Radius.circular(20), topRight: Radius.circular(20));
}

class LikeButton extends StatefulWidget {
  const LikeButton({Key? key}) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;
  bool isDisliked = false;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      IconButton(
          onPressed: () {
            setState(() {
              isLiked = !isLiked;

              if (isLiked) {
                isDisliked = false;
              }
            });
          },
          icon: Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_outlined)),
      const SizedBox(width: 20),
      IconButton(
          onPressed: () {
            setState(() {
              isDisliked = !isDisliked;

              if (isDisliked) {
                isLiked = false;
              }
            });
          },
          icon:
              Icon(isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined)),
    ]);
  }
}
