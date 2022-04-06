// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitracker',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bitracker'),
          centerTitle: true,
        ),
        body: BitrackerPrice()
      ),
    );
  }
}


class BitrackerPrice extends StatefulWidget {
  const BitrackerPrice({ Key? key }) : super(key: key);

  @override
  State<BitrackerPrice> createState() => _BitrackerPriceState();
}

class _BitrackerPriceState extends State<BitrackerPrice> {
  double price = 0;
  double solanaPrice = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => getPrice('solana').then((value) => setState(() => solanaPrice = value,)));
  }
  
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<double> getPrice(cryptoName) async {

    Uri url = Uri.parse('https://9gfx4yhlgg.execute-api.us-east-2.amazonaws.com/prod/v1/crypto/' + cryptoName + '?currency=EUR');
    
    var response = await http.get(
      url,
      headers: {
        "cmc_api_key": "",
      },
    );
    print(response.body);
    return jsonDecode(response.body);    

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Solana',
            ),
            Text(
              '$solanaPrice',
            ),
          ],
        ),
      ],           
    );
  }
}