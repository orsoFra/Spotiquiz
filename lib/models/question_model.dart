class QuestionModel {
  String question;
  List<String> answers;
  String? songURL; //optional, since it could be that the question does not use it
  String? authorId;
  int correctAnswer;
  QuestionModel(this.question, this.answers, this.correctAnswer, [this.songURL, this.authorId]);
}
