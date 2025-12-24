import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/word_hurdlepage.dart';
import 'package:wordle/hurdleprovider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => HurdleProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
