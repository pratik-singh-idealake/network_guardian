
import 'dart:io';

class InternetVerifier {

  static const List<String> _urls = [
    'https://clients3.google.com/generate_204',
    'https://connectivitycheck.gstatic.com/generate_204',
  ];

  static Future<bool> hasInternet() async {
    for (final url in _urls) {
      try {
        final request = await HttpClient()
            .getUrl(Uri.parse(url))
            .timeout(const Duration(seconds: 5));

        request.headers.set('Cache-Control', 'no-cache');
        final response = await request.close();
        await response.drain();

        if (response.statusCode == 204) return true;
      } catch (_) {
        continue;
      }
    }
    return false;
  }
}