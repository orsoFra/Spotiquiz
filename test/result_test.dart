import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:spotiquiz/main.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/loginpage.dart';
import 'package:spotiquiz/screens/main_page.dart';
import 'package:mockito/mockito.dart';
import 'package:spotiquiz/screens/resultpage.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:spotiquiz/services/auth.dart';
import 'widget_test.mocks.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}

void main() {
  testWidgets('ResultPage', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(ResultPage(10)));
    expect(find.byType(Text), findsWidgets);
    expect(find.text(10.toString()), findsOneWidget);
  });
}
