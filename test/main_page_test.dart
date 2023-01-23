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

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MocksAPI extends Mock implements API {}

class MockAuth extends Mock implements Auth {}

class MockStorage extends Mock implements MyStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final mockObserver = MockNavigatorObserver();
  final mockAuth = MockAuth();
  final mockApi = MocksAPI();
  final mockStorage = MockStorage();

  testWidgets('test main page login ok', (tester) async {
    await tester.runAsync(() async {
      await mockNetworkImagesFor(() async {
        when(() => mockStorage.read(key: 'access_token')).thenAnswer((invocation) => Future.value('oks'));
        when(() => mockApi.tryToken()).thenAnswer((((realInvocation) => Future.value(true))));

        await tester.pumpWidget(buildTestableWidget(MainPage(api: mockApi, auth: mockAuth, storage: mockStorage)));
        await tester.pumpAndSettle();
        verify(() => mockStorage.read(key: 'access_token')).called(1);
        verify(() => mockApi.tryToken()).called(1);
        await tester.pumpAndSettle();
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.text('Welcome Back'), findsWidgets);
        expect(find.byType(Swiper), findsWidgets);
      });
    });
  });

  testWidgets('test main page login refresh', (tester) async {
    await tester.runAsync(() async {
      await mockNetworkImagesFor(() async {
        when(() => mockStorage.read(key: 'access_token')).thenAnswer((invocation) => Future.value('oks'));
        when(() => mockApi.tryToken()).thenAnswer((((realInvocation) => Future.value(false))));

        await tester.pumpWidget(buildTestableWidget(MainPage(api: mockApi, auth: mockAuth, storage: mockStorage)));
        await tester.pumpAndSettle();
        verify(() => mockStorage.read(key: 'access_token')).called(1);
        verify(() => mockApi.tryToken()).called(1);
        await tester.pumpAndSettle();
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.text('Welcome Back'), findsWidgets);
        expect(find.byType(Swiper), findsWidgets);
      });
    });
  });

  testWidgets('test main page login failed', (tester) async {
    await tester.runAsync(() async {
      await mockNetworkImagesFor(() async {
        when(() => mockStorage.read(key: 'access_token')).thenAnswer((invocation) => Future.value(null));
        when(() => mockApi.tryToken()).thenAnswer((((realInvocation) => Future.value(false))));

        await tester.pumpWidget(buildTestableWidget(MainPage(api: mockApi, auth: mockAuth, storage: mockStorage)));
        await tester.pumpAndSettle();
        verify(() => mockStorage.read(key: 'access_token')).called(1);
        //verify(() => mockApi.tryToken()).called(1);
        await tester.pumpAndSettle();
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        expect(find.text('Login with Spotify'), findsWidgets);
        expect(find.byType(InkWell), findsWidgets);
      });
    });
  });
}
