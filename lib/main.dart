// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:flutter_project/ui/HomePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  static var routes = <String, WidgetBuilder>{
  '/homePage': (BuildContext context) => new HomePage(),
  };
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bitcracker Price',
      theme: new ThemeData(
        primarySwatch: Colors.lightBlue,
        accentColor: Colors.cyan[600],
        brightness: Brightness.light,
      ),
      home: HomePage(),
    );

  }

}
