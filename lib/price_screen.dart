import 'dart:convert';

import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'INR';
  double currentValue = 0.0;

  DropdownButton<String> getDropDownButton() {
    List<DropdownMenuItem<String>> items = [];
    for (var currency in currenciesList) {
      items.add(DropdownMenuItem(
        value: currency,
        child: Text(currency),
      ));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
      setState(() {
          selectedCurrency = value!;
          makeGetRequest();
      });
      }
    );
  }

  CupertinoPicker getCupertinoPicker() {
    List<Text> items = [];
    for (var currency in currenciesList) {
      items.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {

      },
      children: items,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return getCupertinoPicker();
    } else {
      return getDropDownButton();
    }
  }

  String getText() {
    return '1 BTC = $currentValue $selectedCurrency';
  }

  void updateUI(double value) {
    setState(() {
      currentValue = value;
    });
  }

  Future<void> makeGetRequest() async {
    var url = Uri.parse('https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC$selectedCurrency');
    var headers = {
      'x-ba-key': 'OGUxYjEwZGY2NDc3NDkzMjk1YzRhOWJkZTEyNjgwMjE',
    };
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      updateUI(decodedResponse['last']);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $currentValue $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}


