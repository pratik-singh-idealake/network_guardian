// import 'dart:io';
//
// class InternetVerifier {
//
//   static Future<bool> hasInternet() async {
//     try {
//       final response = await HttpClient()
//           .getUrl(Uri.parse('https://clients3.google.com/generate_204'))
//           .timeout(const Duration(seconds: 5));
//
//       final result = await response.close();
//
//       return result.statusCode == 204;
//     } catch (_) {
//       return false;
//     }
//   }
// }

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
        await response.drain(); // ✅ drain response body properly

        if (response.statusCode == 204) return true;
      } catch (_) {
        continue; // try next url
      }
    }
    return false;
  }
}