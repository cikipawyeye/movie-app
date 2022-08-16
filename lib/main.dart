import 'package:flutter/material.dart';
import 'package:movie_app/screen/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Information',
      theme: ThemeData(fontFamily: "Nunito", primarySwatch: Colors.grey),
      home: const MyHomePage(title: 'MovieDi'),
    );
  }
}
