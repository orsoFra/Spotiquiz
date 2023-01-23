import 'dart:convert';
//import 'dart:html';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mockito/mockito.dart' as mockito;

//import 'package:test/expect.dart';
//import 'package:test/test.dart';

void cannotBeNull(dynamic param) {
  assert(param != null);
}

class MocksAPI extends Mock implements API {}

void main() {}
