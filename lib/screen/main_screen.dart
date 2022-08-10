import 'package:flutter/material.dart';
import 'package:movie_app/screen/content/main_screen_desktop.dart';
import 'package:movie_app/screen/content/main_screen_mobile.dart';

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
