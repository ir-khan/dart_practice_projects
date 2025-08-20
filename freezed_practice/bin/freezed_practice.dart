import 'package:freezed_practice/freezed_practice.dart' as freezed_practice;

void main(List<String> arguments) async {
  final users = await freezed_practice.getResponse();

  users.forEach(print);
}
