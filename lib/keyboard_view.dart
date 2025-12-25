import 'package:flutter/material.dart';

const keyList = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
];

class KeyboardView extends StatelessWidget {
  const KeyboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            for (int i = 0; i <= keyList.length; i++)
              Row(children: keyList[i].map((e) => VirtualKey(letter: e, excluded: false, onPress: (value){

              })).toList()),
          ],
        ),
      ),
    );
  }
}

class VirtualKey extends StatelessWidget {

  final String letter;
  final bool excluded;
  final Function(String) onPress;
  const VirtualKey({super.key, required this.letter, required this.excluded, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: excluded ? Colors.red : Colors.black,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
        ),
        onPressed: (){
          onPress(letter);
        },
        child: Text(letter),
        ),
    );
  }
}
