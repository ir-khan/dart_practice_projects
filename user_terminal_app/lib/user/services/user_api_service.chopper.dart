// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$UserApiService extends UserApiService {
  _$UserApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = UserApiService;

  @override
  Future<Response<dynamic>> createUser({required Map<String, dynamic> body}) {
    final Uri $url = Uri.parse('/users');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteUser({required int id}) {
    final Uri $url = Uri.parse('/users/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> geUsertById({required int id}) {
    final Uri $url = Uri.parse('/users/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAllUser() {
    final Uri $url = Uri.parse('/users');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateUser({
    required int id,
    required Map<String, dynamic> body,
  }) {
    final Uri $url = Uri.parse('/users/${id}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
