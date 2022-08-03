import 'package:flutter/material.dart';
import 'package:movie_app/model/movie_list.dart';

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
                  image:
                      AssetImage("lib/assets/images/background/margo2.jpg")))),
      LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double width = MediaQuery.of(context).size.width;
        // check desktop ver or mobile ver
        return const MobileVer();
      }),
    ])));
  }
}

// mobile ver
class MobileVer extends StatefulWidget {
  const MobileVer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MobileVerState();
}

class _MobileVerState extends State<MobileVer> {
  String? inputSearch;
  Movies? list;
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
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("MovieDi",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 32)),
                            SizedBox(height: 5),
                            Text("All about movies.",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16))
                          ]))),
              // search bar
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  child: Container(
                      constraints: const BoxConstraints(maxHeight: 42),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: TextField(
                                    onChanged: (String value) {
                                      inputSearch = value;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "Search movie..",
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 20),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)))),
                                  ))),
                          CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: IconButton(
                                  splashColor: Theme.of(context).primaryColor,
                                  splashRadius: 250,
                                  onPressed: () {
                                    if (inputSearch != null) {
                                      Movies.getMovies(inputSearch!)
                                          .then((value) {
                                        setState(() {
                                          list = value;
                                        });
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.search)))
                        ],
                      ))),
              // list movie
              Builder(builder: (BuildContext context) {
                String message = "Cari Film";
                if (list != null) {
                  if (list!.movies != null) {
                    return Expanded(
                        child: GridView.count(
                            childAspectRatio: 0.5,
                            crossAxisCount: 2,
                            children: list!.movies!.map((e) {
                              return LayoutBuilder(builder:
                                  (BuildContext context,
                                      BoxConstraints constraints) {
                                return Padding(
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
                                                      constraints.maxHeight *
                                                          0.71),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  child: Image.network(
                                                      e["Poster"],
                                                      width:
                                                          constraints.maxWidth,
                                                      height: constraints
                                                              .maxHeight *
                                                          0.71,
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
                                        ])));
                              });
                            }).toList()));
                  } else {
                    list!.error != null
                        ? message = list!.error!
                        : message =
                            "Koneksi ke database gagal! Periksa koneksi internet Anda.";
                  }
                }

                return SizedBox(
                  height: 200,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.movie_filter,
                            size: 70, color: Colors.black38),
                        SizedBox(height: 10),
                        Text(message)
                      ]),
                );
              })
            ]));
  }

  // Widget getMovies(Movies? list) {
  //   if (list != null) {
  //     if (list.movies != null) {
  //       print(list.response);
  //       return GridView.count(
  //         crossAxisCount: 2,
  //         children: list.movies!.map((e) {
  //           return Card(
  //             child: Text(e["Title"].toString()),
  //           );
  //         }).toList(),
  //       );
  //     } else {
  //       return Text(list.error != null
  //           ? list.error!
  //           : "Koneksi ke database gagal! Periksa koneksi internet Anda.");
  //     }
  //   } else {
  //     return const SizedBox(
  //       height: 200,
  //       child: Center(child: Text("Cari Film")),
  //     );
  //   }
  // }
}
