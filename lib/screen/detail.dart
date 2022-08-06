import 'package:flutter/material.dart';
import 'package:movie_app/model/get_imdb_id.dart';
import 'package:movie_app/model/movie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Detail extends StatefulWidget {
  final String idMovie;
  final bool? isImdbId;

  Detail(this.idMovie, {Key? key, this.isImdbId}) : super(key: key);

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
    Size size = MediaQuery.of(context).size;

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
                        movie!.detail!["Rated"],
                        style: const TextStyle(fontSize: 16),
                      ),
                      Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 25),
                            Text(
                              movie!.detail!["imdbRating"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const Text("/10"),
                          ]),
                      const Icon(Icons.share)
                    ],
                  ),
                ),
                Container(
                  color: const Color.fromARGB(31, 189, 189, 189),
                  padding: const EdgeInsets.only(
                      left: 50, right: 50, bottom: 80, top: 35),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: Text("Released")),
                            const Expanded(child: Text(" : ")),
                            Expanded(child: Text(movie!.detail!["Released"])),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: Text("Runtime")),
                            const Expanded(child: Text(" : ")),
                            Expanded(child: Text(movie!.detail!["Runtime"])),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: Text("Director")),
                            const Expanded(child: Text(" : ")),
                            Expanded(child: Text(movie!.detail!["Director"])),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: Text("Writer")),
                            const Expanded(child: Text(" : ")),
                            Expanded(child: Text(movie!.detail!["Writer"])),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: Text("Actors")),
                            const Expanded(child: Text(" : ")),
                            Expanded(child: Text(movie!.detail!["Actors"])),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: Text("Language")),
                            const Expanded(child: Text(" : ")),
                            Expanded(child: Text(movie!.detail!["Language"])),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: Text("Writer")),
                            const Expanded(child: Text(" : ")),
                            Expanded(child: Text(movie!.detail!["Writer"])),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: Text("Country")),
                            const Expanded(child: Text(" : ")),
                            Expanded(child: Text(movie!.detail!["Country"])),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: Text("Awards")),
                            const Expanded(child: Text(" : ")),
                            Expanded(child: Text(movie!.detail!["Awards"])),
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
                      padding: const EdgeInsets.all(14),
                      child: Text(plot, textAlign: TextAlign.center))
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
