import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:spotiquiz/controllers/timer_controller.dart';

import '../screens/questionpage.dart';
import '../screens/resultpage.dart';

class QuestionController {
  late PageController pageController;
  late BuildContext context;
  late int numPages;
  late int score;
  late TimerController timerController;
  late QuestionPage questionPage;
  late Function stopPlayingCallback;

  QuestionController(Function stopPlayingCallback, int numPages) {
    this.pageController = PageController(initialPage: 0);
    this.numPages = numPages;
    this.stopPlayingCallback = stopPlayingCallback;
    this.reset();
  }

  void setContext(BuildContext context) {
    this.context = context;
  }

  void setTimerController(TimerController timerController) {
    this.timerController = timerController;
  }

  void reset() {
    this.score = 0;
  }

  void nextPage() {
    if (pageController.page?.toInt() == numPages - 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultPage(this.score)));
      timerController.pause();
    } else {
      pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeInExpo);
      this.timerController.resetTimerAndStart();
    }
  }
}
