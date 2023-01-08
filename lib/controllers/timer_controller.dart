import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'question_controller.dart';

// We use get package for our state management

class TimerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Lets animated our progress bar

  late AnimationController _animationController;
  late Animation _animation;
  // so that we can access our animation outside
  Animation get animation => this._animation;
  AnimationController get animationController => _animationController;

  late QuestionController questionController;

  TimerController(QuestionController questionController){
    this.questionController = questionController;
  }

  // called immediately after the widget is allocated memory
  @override
  void onInit() {
    // Our animation duration is 30 s
    // so our plan is to fill the progress bar within 60s
    _animationController =
        AnimationController(duration: Duration(seconds: 40), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        // update like setState
        update();
      });

    // start our animation
    // Once 60s is completed go to the next qn
    _animationController.forward().whenComplete(nextQuestion);
    super.onInit();
  }

  void nextQuestion() {
    print("next question");
    questionController.nextPage();
  }

  void resetTimer() {
    // Reset the counter
    _animationController.reset();
  }

  void resetTimerAndStart() {
    // Reset the counter
    _animationController.reset();

    // Then start it again
    // Once timer is finish go to the next qn
    _animationController.forward().whenComplete(nextQuestion);
  }

  // // called just before the Controller is deleted from memory
  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }

}