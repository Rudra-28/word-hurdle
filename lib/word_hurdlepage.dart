import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/helper_function.dart';
import 'package:wordle/hurdleprovider.dart';
import 'package:wordle/keyboard_view.dart';
import 'package:wordle/wordle.dart';
import 'package:wordle/wordle_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  //here initstate is not used because the providers, theme, etc are not ready to use, widget is created but tree not built,
  //initState() runs too early (widget exists, tree incomplete).
  //didChangeDependencies() waits for providers to register in the tree.
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  
  void didChangeDependencies() {
    Provider.of<HurdleProvider>(context, listen: false).init();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF1A1B1E), // Dark Wordle-like background
    appBar: AppBar(
      title: const Text(
        'HURDLE',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          letterSpacing: 6,
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF1A1B1E),
      elevation: 0,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final gridWidth = constraints.maxWidth * 0.85;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Game Grid
              SizedBox(
                height: 420,
                width: gridWidth,
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) => GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: provider.hurldeBoard.length,
                    itemBuilder: (context, index) {
                      final wordle = provider.hurldeBoard[index];
                      return TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) =>
                            Transform.scale(scale: value, child: child),
                        child: WordleView(wordle: wordle),
                      );
                    },
                  ),
                ),
              ),
              
              // Keyboard
              SizedBox(
                height: 220,
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) => KeyboardView(
                    onPressed: (value) => provider.inputLetter(value),
                    excludedLetters: provider.excludedLetters,
                  ),
                ),
              ),
              
              // Action Buttons
              Consumer<HurdleProvider>(
                builder: (context, provider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF787C7E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: provider.count == 5 ? null : provider.deleteLetter,
                          child: const Text(
                            'DELETE',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: provider.count == 5 
                                ? const Color(0xFF538D4E) 
                                : const Color(0xFF787C7E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: provider.count == 5 
                              ? () {
                                  if (!provider.isAValidWord) {
                                    showMsg(context, 'Wrong Word, Please try again');
                                    return;
                                  }
                                  if (provider.shouldCheckForAnswer) {
                                    provider.checkAnswer();
                                  }
                                  if (provider.wins) {
                                    provider.markletterOnBoard;
                                    showResult(
                                      context: context,
                                      title: 'You Win!!!',
                                      body: 'The word was ${provider.targetWord}',
                                      onPlayAgain: () {
                                        Navigator.pop(context);
                                        provider.reset();
                                      },
                                      onCancel: () {
                                        Navigator.pop(context);
                                        provider.reset();
                                      },
                                    );
                                  } else if (provider.noAttemptsLeft) {
                                    showResult(
                                      context: context,
                                      title: 'You Lost',
                                      body: 'The word is ${provider.targetWord}',
                                      onPlayAgain: () {
                                        Navigator.pop(context);
                                        provider.reset();
                                      },
                                      onCancel: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  }
                                }
                              : null,
                          child: const Text(
                            'SUBMIT',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

}
