// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors_in_immutables

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
  double newPrice = 0;
  String cryptoName = '';
  TextEditingController textController = TextEditingController();

  Future<double> getPrice() async {

    Uri url = Uri.parse('https://9gfx4yhlgg.execute-api.us-east-2.amazonaws.com/prod/v1/crypto/' + cryptoName + '?currency=EUR');
    
    var response = await http.get(
      url,
      headers: {
        "cmc_api_key": "",
      },
    );

    return jsonDecode(response.body);    

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: textController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter the cryptocurrency name',
                ),
              ),
            ),
          ], 
        ),
        SizedBox(
          height: 20,
        ),
        Text('$price'),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            cryptoName = textController.text;
            getPrice().then(
              (value) => setState(
                () => price = value
              ),
            );
          }, 
          child: const Text('Get Price'),
        )
      ],           
    );
  }
}