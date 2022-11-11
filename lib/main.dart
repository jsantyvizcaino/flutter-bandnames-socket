import 'package:band_names/src/providers/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/src/pages/pages.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        )
      ],
      child: MaterialApp(
        title: 'Material App',
        initialRoute: HomePage.routerName,
        routes: {
          HomePage.routerName: (_) => const HomePage(),
          StatusPage.routerName: (_) => const StatusPage(),
        },
      ),
    );
  }
}
