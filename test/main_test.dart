import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/screens/main_page.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:spotiquiz/services/auth.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: const MediaQueryData(), child: MaterialApp(home: widget));
}

class MocksAPI extends Mock implements API {}

class MockAuth extends Mock implements Auth {}

class MockStorage extends Mock implements MyStorage {}

void main() {
  final mockAuth = MockAuth();
  final mockApi = MocksAPI();
  final mockStorage = MockStorage();
  testWidgets('test main', (widgetTester) async {
    await widgetTester.runAsync(() async {
      await mockNetworkImagesFor(() async {
        await widgetTester.pumpWidget(MaterialApp(
          title: 'Spotiquiz',
          theme: ThemeData.dark(),
          home: MainPage(
            auth: mockAuth,
            api: mockApi,
            storage: mockStorage,
          ),
        ));
      });
    });
  });
}
