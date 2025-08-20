import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:freezed_practice/models/user.dart';

Future<List<User>> getResponse() async {
  final uri = Uri.parse('https://fake-json-api.mock.beeceptor.com/users');

  try {
    final res = await http.get(uri);
    final List decodedResult = jsonDecode(res.body);
    return decodedResult.map((result) => User.fromJson(result)).toList();
  } catch (e) {
    throw Exception(e);
  }
}
