import 'package:flutter/material.dart';
import 'package:movie_app/model/movie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Detail extends StatelessWidget {
  final String idMovie;

  const Detail(this.idMovie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Movie? movie;
    Size size = MediaQuery.of(context).size;

    Movie.getDetailMovie(idMovie).then((value) {
      movie = value;
      print(movie!.detail!["Title"]);
    });

    return Scaffold(
        appBar: AppBar(title: const Text("")),
        body: SlidingUpPanel(
          body: Padding(
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text("--Movie Title--",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            "https://m.media-amazon.com/images/M/MV5BNDYxNjQyMjAtNTdiOS00NGYwLWFmNTAtNThmYjU5ZGI2YTI1XkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg",
                            fit: BoxFit.cover,
                          )),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                              color: Colors.black,
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Text("Sci-fi",
                                    style: TextStyle(color: Colors.white)),
                              )),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                              color: Colors.black,
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Text("Superhero",
                                    style: TextStyle(color: Colors.white)),
                              )),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                              color: Colors.black,
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Text("Action",
                                    style: TextStyle(color: Colors.white)),
                              )),
                        )
                      ],
                    )
                  ]),
            ),
          ),
          minHeight: size.height * 0.03,
          panelBuilder: (controller) {
            String plot =
                "Earth's mightiest heroes must come together and learn to fight as a team if they are going to stop the mischievous Loki and his alien army from enslaving humanity.";
            return SingleChildScrollView(
                controller: controller,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          child: const Text("--", textAlign: TextAlign.center)),
                      Container(
                          padding: EdgeInsets.all(8),
                          child: Text(plot, textAlign: TextAlign.center))
                    ]));
          },
        ));
  }
}
