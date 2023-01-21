import 'dart:math';

import 'package:spotiquiz/services/data.dart' as dAPI;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}

//class MockData extends Mock implements dAPI;
void main() {}
