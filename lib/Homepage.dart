import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/hurdleprovider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  //here initstate is not used because the providers, theme, etc are not ready to use, widget is created but tree not built,
  //initState() runs too early (widget exists, tree incomplete). 
  //didChangeDependencies() waits for providers to register in the tree.
  void didChangeDependencies() {
    Provider.of<HurdleProvider>(context,listen: false).init();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wordle')),
      body: Center(child: Column(children: [

        ],
      )),
    );
  }
}
