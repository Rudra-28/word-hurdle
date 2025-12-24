class Wordle {
  String letter;
  bool existingInTarget;
  bool doesNotExistInTarget;

  Wordle({
    required this.letter,
    this.doesNotExistInTarget=false,
    this.existingInTarget=false,
  });
}

