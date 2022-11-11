part of 'services.dart';

class RajaOngkirService {
  static Future<http.Response> getOngkir() {
    return http.post(Uri.https(Const.baseUrl, '/starter/cost'),
        headers: <String, String>{
          'content-type': 'application/json; charset=utf-8',
          'key': Const.apiKey
        },
        body: jsonEncode(<String, dynamic>{
          'origin': '501',
          'destination': '114',
          'weight': 1700,
          'courier': 'jne'
        }));
  }
}
