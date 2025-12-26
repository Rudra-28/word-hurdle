import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/hurdleprovider.dart';
import 'package:wordle/keyboard_view.dart';
import 'package:wordle/wordle.dart';
import 'package:wordle/wordle_view.dart';

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
    Provider.of<HurdleProvider>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wordle')),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.70,
              child: Container(
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) => GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: provider.hurldeBoard.length,
                    itemBuilder: (context, index) {
                      //Object is created for hurdleBoard from the WordleView,
                      final wordle = provider.hurldeBoard[index];
                      return WordleView(wordle: wordle);
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              child: Consumer<HurdleProvider>(
                builder: (context, provider, child) => KeyboardView(
                  onPressed: (value) {
                    provider.inputLetter(value);
                  },
                  excludedLetters: provider.excludedLetters,
                ),
              ),
            ),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: (){
                        provider.deleteLetter();
                      }, child:const Text("DELETE")),
                      ElevatedButton(onPressed: (){
                        if(!provider.isAValidWord){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not a Word in my Dictionary")));
                          return;
                        }
                      }, child:const Text("SUBMIT"))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
