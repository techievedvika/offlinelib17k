import 'dart:convert';

import 'package:http/http.dart' as http;
import '../auth/session_manager.dart';

// Everything from package:http stays available as http.Response, http.MultipartFile, ...
// except get / post / MultipartRequest, which are replaced by the versions below.
export 'package:http/http.dart' hide get, post, MultipartRequest;

class _AuthedClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await SessionManager.token();
    final hasToken = token != null && token.isNotEmpty;

    request.headers['Accept'] = 'application/json';
    request.headers['X-Device-UUID'] = await SessionManager.deviceUuid();
    if (hasToken) request.headers['Authorization'] = 'Bearer $token';

    final streamed = await _inner.send(request);

    final path = request.url.path;
    final isAuthRoute = path.endsWith('/login') || path.endsWith('/logout');

    if (hasToken && !isAuthRoute && (streamed.statusCode == 401 || streamed.statusCode == 403)) {
      final res = await http.Response.fromStream(streamed);
      SessionManager.handleAuthFailure(res.statusCode, res.body);
      // hand the same response back so the caller's own code still works
      return http.StreamedResponse(
        Stream.value(res.bodyBytes),
        res.statusCode,
        contentLength: res.bodyBytes.length,
        request: request,
        headers: res.headers,
        reasonPhrase: res.reasonPhrase,
      );
    }
    return streamed;
  }
}

final http.Client _client = _AuthedClient();

Future<http.Response> get(Uri url, {Map<String, String>? headers}) =>
    _client.get(url, headers: headers);

Future<http.Response> post(Uri url,
    {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    _client.post(url, headers: headers, body: body, encoding: encoding);

class MultipartRequest extends http.MultipartRequest {
  MultipartRequest(super.method, super.url);

  @override
  Future<http.StreamedResponse> send() => _client.send(this);
}