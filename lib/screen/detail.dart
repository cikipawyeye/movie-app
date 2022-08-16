import 'package:flutter/material.dart';
import 'package:movie_app/model/movie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Detail extends StatefulWidget {
  final String _idMovie;
  final bool? isImdbId;

  const Detail(this._idMovie, {Key? key, this.isImdbId}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Movie? _movie;
  List<String>? _genre;

  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    if (_movie == null) {
      Movie.getMovie(int.parse(widget._idMovie)).then((value) {
        setState(() {
          _movie = value;
        });
      });

      return const Scaffold(body: Center(child: Text("Loading data...")));
    }

    if (_movie!.success != null && !_movie!.success! ||
        _movie!.imdbResponse == "False") {
      return Scaffold(
          body: Center(
              child: Text(
                  _movie!.statusMessage ?? "Error getting data. Try reload")));
    }

    _genre = _movie!.genres!.toString().split(", ");

    return content();
  }

  // rating, genre, btn like & share
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

    // screen dpi above 700 : desktop
    if (size.width > 700) {
      return Stack(children: [
        // movie image
        Container(
          constraints: BoxConstraints(maxHeight: size.height * 0.6),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0),
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.dstATop),
              image: NetworkImage(
                _movie!.backdropPath!,
              ),
            ),
          ),
        ),
        // movie detail
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: padding),
          child: Column(
            children: [
              // movie title
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(_movie!.title!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: fontSize + 8,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))),
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
                                    _movie!.posterPath!,
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
                              _movie!.rated!,
                              style: TextStyle(
                                  color: Colors.white, fontSize: fontSize + 2),
                            ),
                            const SizedBox(width: 40),
                            Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 25),
                                  Text(
                                    _movie!.imdbRating!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: fontSize + 6),
                                  ),
                                  Text("/10",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontSize - 2)),
                                ])
                          ])),
                  // genre
                  Builder(builder: (context) {
                    if (_genre!.length < 5) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _genre!.map((e) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                  color:
                                      const Color.fromARGB(255, 241, 240, 240),
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
                        children: _genre!.map((e) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                  color:
                                      const Color.fromARGB(255, 241, 240, 240),
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
                            Icon(
                              Icons.share,
                              color: Color.fromARGB(255, 183, 183, 183),
                            )
                          ]))
                ])))
              ]),
            ],
          ),
        ),
      ]);

      // screen dpi under 325 : mini mobile/desktop
    } else if (size.width < 325) {
      return Column(
        children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            // poster
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: BoxConstraints(maxHeight: size.height * 0.5),
                child: Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        _movie!.posterPath!,
                        fit: BoxFit.contain,
                      )),
                ),
              ),
            ),
            // movie title
            Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 18),
                child: Text(_movie!.title!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold))),
            // genre
            Column(
              mainAxisSize: MainAxisSize.min,
              children: _genre!.map((e) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                        color: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(e,
                              style: const TextStyle(color: Colors.black)),
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
                    _movie!.rated!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 25),
                        Text(
                          _movie!.imdbRating!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Text("/10"),
                      ]),
                  const LikeButton(),
                  const Icon(Icons.share,
                      color: Color.fromARGB(255, 183, 183, 183))
                ]))
          ]),
        ],
      );

      // screen dpi > 325 & < 700 : mobile
    } else {
      return Stack(
        children: [
          // movie backdrop image
          Container(
            constraints: BoxConstraints(maxHeight: size.height * 0.55),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.dstATop),
                image: NetworkImage(
                  _movie!.backdropPath!,
                ),
              ),
            ),
          ),
          Column(mainAxisSize: MainAxisSize.min, children: [
            // poster
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0, left: 8.0, right: 8.0, top: 70),
              child: Container(
                constraints: BoxConstraints(maxHeight: size.height * 0.5),
                child: Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        _movie!.posterPath!,
                        fit: BoxFit.contain,
                      )),
                ),
              ),
            ),
            // movie title
            Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 18),
                child: Text(_movie!.title!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold))),
            // genre
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _genre!.map((e) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                      color: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(e,
                            style: const TextStyle(color: Colors.black)),
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
                        _movie!.rated!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 25),
                            Text(
                              _movie!.imdbRating!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const Text("/10"),
                          ]),
                      const Icon(
                        Icons.share,
                        color: Color.fromARGB(255, 183, 183, 183),
                      )
                    ]))
          ]),
        ],
      );
    }
  }

  // movie description
  Scaffold content() {
    Size size = MediaQuery.of(context).size;
    double padding = 40;
    double fontSize = 14;
    if (size.width > 700) {
      padding = 70;
      fontSize = 17;
    }
    if (size.width > 1000) {
      padding = 110;
    }
    if (size.width > 1200) {
      padding = 160;
      fontSize = 19;
    }
    if (size.width > 1400) {
      padding = 200;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Movie"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(children: [
        // movie information
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
                  // movie information
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text("Released",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                flex: 4,
                                child: Text(_movie!.releaseDate!,
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text("Runtime",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                flex: 4,
                                child: Text(_movie!.runtime!,
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text("Director",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                flex: 4,
                                child: Text(_movie!.director!,
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text("Writer",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                flex: 4,
                                child: Text(_movie!.writer!,
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text("Actors",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                flex: 4,
                                child: Text(_movie!.actor!,
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text("Language",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                flex: 4,
                                child: Text(_movie!.language!,
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text("Writer",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                flex: 4,
                                child: Text(_movie!.writer!,
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text("Country",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                flex: 4,
                                child: Text(_movie!.country!,
                                    style: TextStyle(fontSize: fontSize))),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text("Awards",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                child: Text(" : ",
                                    style: TextStyle(fontSize: fontSize))),
                            Expanded(
                                flex: 4,
                                child: Text(_movie!.awards!,
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
            String plot = _movie!.plot!;
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
          color: const Color.fromARGB(255, 183, 183, 183),
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
          color: const Color.fromARGB(255, 183, 183, 183),
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
