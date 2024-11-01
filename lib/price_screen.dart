import 'package:flutter/material.dart';
import "coin_data.dart";
import "package:flutter/cupertino.dart";
import "dart:io" show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  PriceScreenState createState() => PriceScreenState();
}

class PriceScreenState extends State<PriceScreen> {
  String selectCurrency = "USD";
  Map<String, dynamic> dataMap = {};
  CoinData coin = CoinData();
  dynamic dataBTC;
  dynamic dataETH;
  dynamic dataLTC;
  DropdownButton getAndriodDropdown() {
    return DropdownButton(
      value: selectCurrency,
      items: currenciesList.map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Center(child: Text(currency)),
        );
      }).toList(),
      onChanged: (value) => setState(() {
        selectCurrency = value!;
        getData();
      }),
    );
  }

  CupertinoPicker getIosPicker() {
    return CupertinoPicker(
      itemExtent: 25.0,
      children: currenciesList.map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Center(child: Text(currency)),
        );
      }).toList(),
      onSelectedItemChanged: (index) => setState(() {
        selectCurrency = currenciesList[index];
        getData();
      }),
    );
  }

  Future<void> getData() async {
    var newDataBTC = await coin.getExchangeRate("BTC", selectCurrency);
    var newDataETH = await coin.getExchangeRate("ETH", selectCurrency);
    var newDataLTC = await coin.getExchangeRate("LTC", selectCurrency);
    setState(() {
      dataBTC = newDataBTC;
      dataETH = newDataETH;
      dataLTC = newDataLTC;
    });
    dataMap = {
      "BTC": dataBTC,
      "ETH": dataETH,
      "LTC": dataLTC,
      // Add more currencies as needed
    };
  }

  Padding card(String crypto) {
    final rate = dataMap[crypto]?['rate'];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = ${rate != null ? rate.toStringAsFixed(0) : 'N/A'}  $selectCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              card("BTC"),
              card("ETH"),
              card("LTC"),
            ],
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? getIosPicker() : getAndriodDropdown()),
        ],
      ),
    );
  }
}
