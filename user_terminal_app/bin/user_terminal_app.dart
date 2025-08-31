import 'package:user_terminal_app/features/user/presentation/user_controller.dart';

// final chopper = ChopperClient(
//   baseUrl: Uri.parse("http://localhost:3000"),
//   services: [UserApiService.create()],
//   converter: JsonConverter(),
//   interceptors: [HttpLoggingInterceptor()],
// );

void main(List<String> arguments) async {
  UserController(arguments).validate();
}
