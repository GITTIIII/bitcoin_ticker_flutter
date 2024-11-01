import 'package:flutter_dotenv/flutter_dotenv.dart';
import "dart:convert" as convert;
import "package:http/http.dart" as http;

const coinApiURL = "https://rest.coinapi.io/v1/exchangerate";

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'THB',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  var data;
  Future<dynamic> getExchangeRate(String crypto, String selectCurrency) async {
    var url = Uri.parse(
        "$coinApiURL/$crypto/$selectCurrency?apiKey=${dotenv.env['COIN_API_KEY']}");
    http.Response res = await http.get(url);
    if (res.statusCode == 200) {
      data = convert.jsonDecode(res.body);
      return data;
    } else {
      print(res.statusCode);
    }
  }
}
