import 'dart:convert';

import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/models/card.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/userpage.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:spotiquiz/services/data.dart';
import 'package:spotiquiz/services/firebase_test_service.dart';
import 'package:spotiquiz/services/questionApi.dart';
import 'package:http/http.dart' as http;

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}

class MockAPI extends Mock implements API {}

class MockData extends Mock implements Data {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  MockAPI mockAPI = MockAPI();
  MockData mocksD = MockData();
  MockHttpClient mockHttpClient = MockHttpClient();

  // test the image of profile
  testWidgets('testUserImageProfile', (tester) async {
    await tester.runAsync(
      () async {
        await mockNetworkImagesFor(() async {
          when(() => mockAPI.getInfoUser(mockHttpClient)).thenAnswer((invocation) => Future.value(
                {'imageUrl': '', 'display_name': 'flutterproject', 'email': 'flutterproject@gmail.com', 'product': 'premium'},
              ));
          when(() => mocksD.getUserData())
              .thenAnswer((invocation) => Future.value({'name': '', 'numPerfectQuizzes': 'flutterproject', 'numQuizzes': 'flutterproject@gmail.com', 'totalScore': 'premium'}));
          await tester.pumpWidget(buildTestableWidget(UserPage.test(
            dA: mocksD,
            api: mockAPI,
          )));
          verifyNever((() => mockAPI.getInfoUser(mockHttpClient))).called(0);
          //verify((() => mocksD.getUserData()).);
          expect(find.byType(CircularProgressIndicator), findsOneWidget);

          // TODO: why hasData is never true?
          // expectLater(find.image(const NetworkImage('')), findsOneWidget);
          // expectLater(find.byType(NetworkImage), findsOneWidget);
        });
      },
    );
  });
}
