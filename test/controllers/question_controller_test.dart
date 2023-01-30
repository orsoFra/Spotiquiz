import 'package:flutter/widgets.dart';
import 'package:spotiquiz/controllers/question_controller.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotiquiz/controllers/timer_controller.dart';

class MockTimerController extends Mock implements TimerController {}
class MockPageController extends Mock implements PageController {}


void main(){
  test('test initialization', (){
    // get the resources needed for testing
    void callback() => {};
    final qa = QuestionController(callback, 10);

    // test
    expect(qa.score, 0);
    expect(qa.numPages, 10);
    expect(qa.pageController.initialPage, 0);
  });

  test('test score', (){
    // get the resources needed for testing
    void callback() => {};
    final qa = QuestionController(callback, 10);

    // test
    qa.score += 10;
    expect(qa.score, 10);
    qa.reset();
    expect(qa.score, 0);
  });


}



