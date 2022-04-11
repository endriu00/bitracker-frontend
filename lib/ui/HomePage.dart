// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors_in_immutables
import 'dart:async';
import 'package:flutter_project/globalVariables.dart';
import 'package:flutter_project/ui/HistroyPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitracker',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Bitracker'),
            centerTitle: true,
          ),
          body: BitrackerPrice()),
    );
  }
}

class BitrackerPrice extends StatefulWidget {
  const BitrackerPrice({Key? key}) : super(key: key);

  @override
  State<BitrackerPrice> createState() => _BitrackerPriceState();
}

class _BitrackerPriceState extends State<BitrackerPrice> {
  double solanaPrice = 0;
  double ethereumPrice = 0;
  TextEditingController cryptoSearchController = new TextEditingController();
  List<Widget> dynamicCryptoList = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 15),
        (Timer t) => getPrice('solana').then((value) => setState(
              () => solanaPrice = value,
            )));
    //timer = Timer.periodic(Duration(seconds: 15), (Timer t) => getPrice('bitcoin').then((value) => setState(() => solanaPrice = value,)));
    timer = Timer.periodic(
        Duration(seconds: 15),
        (Timer t) => getPrice('ethereum').then((value) => setState(
              () => ethereumPrice = value,
            )));
    //timer = Timer.periodic(Duration(seconds: 15), (Timer t) => getPrice('alpaca-finance').then((value) => setState(() => solanaPrice = value,)));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<double> getPrice(cryptoName) async {
    Uri url = Uri.parse(
        'https://9gfx4yhlgg.execute-api.us-east-2.amazonaws.com/prod/v1/crypto/' +
            cryptoName +
            '?currency=EUR');

    var response = await http.get(
      url,
      headers: {
        "cmc_api_key": "",
      },
    );

    return jsonDecode(response.body);
  }

  void addCryptoElement() {
    if (cryptoSearchController.text != "500 error") {
      setState(() {
        dynamicCryptoList.add(cryptoElement());
      });
    }
  }

  Widget cryptoElement() {
    return Container(
        color: const Color(0xff232d37),
        child: Flexible(
            flex: 1,
            child: Column(children: [
              Row(
                children: <Widget>[
                  Container(
                      child: Row(
                    children: <Widget>[
                      Text(
                        '${cryptoSearchController.text}',
                        style: TextStyle(
                          color: buttonColor,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                        height: 20,
                      ),
                      Text(
                        '234',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 214, 170, 37),
                          fontSize: 26,
                        ),
                      ),
                    ],
                  )),
                   Spacer(),
                  Container(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(HistoryPage(
                            crypto: '${cryptoSearchController.text}',
                          ));
                        },
                        child: Text("Hystory"),
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff232d37),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Text(
                'Solana',
                style: TextStyle(
                  color: buttonColor,
                  fontSize: 26,
                ),
              ),
              const SizedBox(
                width: 20,
                height: 20,
              ),
              Text(
                '$solanaPrice',
                style: const TextStyle(
                  color: Color.fromARGB(255, 214, 170, 37),
                  fontSize: 26,
                ),
              ),
              Spacer(),
               ElevatedButton(
                    onPressed: () {
                      Get.to(HistoryPage(
                        crypto: 'Solana',
                      ));
                    },
                    child: Text("Hystory"),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
          Row(
            children: <Widget>[
              const Text(
                'Ethereum',
                style: TextStyle(
                  color: buttonColor,
                  fontSize: 26,
                ),
              ),
              const SizedBox(
                width: 20,
                height: 20,
              ),
              Text(
                '$solanaPrice',
                style: const TextStyle(
                  color: Color.fromARGB(255, 214, 170, 37),
                  fontSize: 26,
                ),
              ),
              Spacer(),
              Expanded(
                  child: Container(
                      child: ElevatedButton(
                onPressed: () {
                  Get.to(HistoryPage(
                    crypto: "Ethereum",
                  ));
                },
                child: Text("Hystory"),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              )))
            ],
          ),
          Container(
              child: Column(children: [
            if (!dynamicCryptoList.isEmpty)
              for (int i = 0; i < dynamicCryptoList.length; i++) 
                dynamicCryptoList[i]
              
          ])),
          Row(children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20),
              width: 270,
              height: 40,
              child: TextField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: cryptoSearchController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  hintText: "Insert new Crypto",
                ),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            FloatingActionButton(
              onPressed: addCryptoElement,
              tooltip: "add",
              child: Icon(Icons.search),
            ),
          ])
        ],
      ),
    );
  }
}

class CryptoRow extends StatelessWidget {
  const CryptoRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
