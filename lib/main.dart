import 'dart:io';

import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/screens/tabs_screen.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'application.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    setWindowTitle('Optimalizačné algoritmy');
    setWindowMinSize(const Size(600, 500));
    setWindowMaxSize(Size.infinite);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Application(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Optimalizačné algoritmy',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TabsScreen(),
      ),
    );
  }
}
