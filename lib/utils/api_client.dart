import 'package:http/http.dart' as http;

/// Shared GET with retries — helps Render free-tier cold starts on Flutter web.
Future<http.Response> apiGet(Uri uri, {int retries = 3}) async {
  Object? lastError;

  for (var attempt = 0; attempt < retries; attempt++) {
    try {
      final response = await http.get(uri);
      return response;
    } catch (e) {
      lastError = e;
      if (attempt < retries - 1) {
        await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
      }
    }
  }

  throw lastError ?? Exception('Request failed');
}

/// Append a cache-busting query param so browsers always fetch fresh JSON.
Uri cacheBust(Uri uri) {
  final params = Map<String, String>.from(uri.queryParameters);
  params['_'] = DateTime.now().millisecondsSinceEpoch.toString();
  return uri.replace(queryParameters: params);
}
