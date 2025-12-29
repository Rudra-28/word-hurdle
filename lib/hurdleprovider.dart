import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart' as words;
import 'package:wordle/wordle.dart';

class HurdleProvider extends ChangeNotifier {
  final random = Random.secure();
  List<String> totalwords = [];
  List<String> rowInputs = [];
  List<String> excludedLetters = [];
  List<Wordle> hurldeBoard = [];
  String targetWord = '';
  int count = 0;
  int index=0;
  final lettersPerRow = 5;
  final totalAttempts=6;
  int attempts=0;
  bool wins=false;

  get shouldCheckForAnswer => rowInputs.length==lettersPerRow;

  init() {
    //Retrieving words only with 5 characters
    totalwords = words.all.where((element) => element.length == 5).toList();
    generateBoard();
    generateRandomWord();
  }

  generateBoard() {
    hurldeBoard = List.generate(30, (index) => Wordle(letter: ''));
  }

  generateRandomWord() {
    //Here totalwords consist of the words with 5 letters but in List due to which they are serialized from 0 to MaxNumber.
    targetWord = totalwords[random.nextInt(totalwords.length)].toUpperCase();
    print(targetWord);
  }

  bool get isAValidWord => totalwords.contains(rowInputs.join('').toLowerCase());


  inputLetter(String letter) {
    if (count < lettersPerRow) {
      rowInputs.add(letter);
      hurldeBoard[index]= Wordle(letter: letter);
      index++;
      count++;
      notifyListeners();
    }
  }

  void deleteLetter(){
    if(rowInputs.isNotEmpty){
      rowInputs.removeAt(rowInputs.length-1);
      //print(rowInputs); 
    }
    if(count>0){
      hurldeBoard[index-1]=Wordle(letter: '');
      count--;
      index--;
    }
    notifyListeners();
  }

  void checkAnswer(){
    final input = rowInputs.join('');
    if(targetWord==input){
      wins=true;
    }else{
      markletterOnBoard();
      if(attempts<totalAttempts){
        _goToNextRow();
      }
    }
  }

  void markletterOnBoard(){
    for(int i=0;i<hurldeBoard.length; i++){
      if(hurldeBoard[i].letter.isNotEmpty && targetWord.contains(hurldeBoard[i].letter)){
        hurldeBoard[i].existingInTarget=true;
      } else if(hurldeBoard[i].letter.isNotEmpty && !targetWord.contains(hurldeBoard[i].letter)){
        hurldeBoard[i].doesNotExistInTarget=true;
        excludedLetters.add(hurldeBoard[i].letter);
      }
    }
    notifyListeners();
  }

  void _goToNextRow(){
    attempts++;
    count=0;
    rowInputs.clear();
  }

}
