import 'package:spotiquiz/models/question_model.dart';

class QuizModel {
  String title;
  List<QuestionModel> questions;
  int? points;
  DateTime date_quiz;
  QuizModel(this.title, this.questions, this.date_quiz, [this.points]);

  setPoints(int points) {
    this.points = points;
  }
}
