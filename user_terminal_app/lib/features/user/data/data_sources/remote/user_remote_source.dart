import 'package:chopper/chopper.dart';

part "user_remote_source.chopper.dart";

@ChopperApi(baseUrl: "/users")
abstract class UserRemoteSource extends ChopperService {
  static UserRemoteSource create([ChopperClient? client]) =>
      _$UserRemoteSource(client);

  @POST()
  Future<Response> createUser({@Body() required  Map<String, dynamic> body});

  @DELETE(path: '/{id}')
  Future<Response> deleteUser({@Path('id') required int id});

  @GET(path: '/{id}')
  Future<Response> geUsertById({@Path('id') required int id});

  @GET()
  Future<Response> getAllUser();

  @PATCH(path: '/{id}')
  Future<Response> updateUser({
    @Path('id') required int id,
    @Body() required  Map<String, dynamic> body
  });
}
