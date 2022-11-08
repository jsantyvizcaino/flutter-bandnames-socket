import 'package:flutter/material.dart';

import 'package:band_names/src/pages/pages.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: HomePage.routerName,
      routes: {
        HomePage.routerName: (_) => const HomePage(),
      },
    );
  }
}
