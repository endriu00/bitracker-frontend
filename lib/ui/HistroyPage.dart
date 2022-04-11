import 'dart:async';
import 'dart:core';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_project/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../entity/CryptoEntity.dart';

class HistoryPage extends StatefulWidget {
  String crypto;

  HistoryPage({Key? key, required this.crypto}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HistoryPageState(crypto);
}

class HistoryPageState extends State<HistoryPage> {
  DateTime startTime = DateTime(2000);
  DateTime endTime = DateTime(2000);
  String crypto = " ";
  TextEditingController maxResultController = new TextEditingController();
  HistoryPageState(this.crypto);

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a)
  ];

  List<Widget> dynamicListBar = [];
  List<CryptoEntity> result = [
    new CryptoEntity(
        price: 34000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 1)),
    new CryptoEntity(
        price: 35000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 2)),
    new CryptoEntity(
        price: 36000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 3)),
    new CryptoEntity(
        price: 37000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 4)),
    new CryptoEntity(
        price: 31000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 5)),
    new CryptoEntity(
        price: 32000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 6)),
    new CryptoEntity(
        price: 38000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 7)),
    new CryptoEntity(
        price: 50000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 8)),
    new CryptoEntity(
        price: 12000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 9)),
    new CryptoEntity(
        price: 3000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 10)),
    new CryptoEntity(
        price: 30000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 11)),
    new CryptoEntity(
        price: 32000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 12)),
    new CryptoEntity(
        price: 31000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 13)),
    new CryptoEntity(
        price: 36000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 14)),
    new CryptoEntity(
        price: 20000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 15)),
    new CryptoEntity(
        price: 10000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 16)),
    new CryptoEntity(
        price: 12000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 17)),
    new CryptoEntity(
        price: 15000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 18)),
    new CryptoEntity(
        price: 17000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 19)),
    new CryptoEntity(
        price: 40000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 20)),
    new CryptoEntity(
        price: 41000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 21)),
    new CryptoEntity(
        price: 42000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 22)),
    new CryptoEntity(
        price: 43000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 23)),
    new CryptoEntity(
        price: 5000, name: "Bitcoin", dateResult: DateTime.utc(2000, 12, 24)),
  ];

  List<FlSpot> addResultToGraph() {
    List<FlSpot> results = [];
    result.forEach((element) => results
        .add(new FlSpot(element.dateResult.day.toDouble(), element.price)));
    return results;
  }

  void addElement() {
    setState(() {
      dynamicListBar.add(element());
    });
  }

  Widget element() {
    return Container(
        width: 300,
        height: 300,
        color: Colors.black,
        child: Flexible(
            flex: 1,
            child: new Card(
              child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (_, index) {
                  return new Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          margin: new EdgeInsets.only(left: 10.0),
                          child: new Text("${result[index]}"),
                        ),
                        new Divider()
                      ],
                    ),
                  );
                },
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    Widget leftTitleWidgets(double value, TitleMeta meta) {
      const style = TextStyle(
        color: Color(0xffffffff),
        fontWeight: FontWeight.bold,
        fontSize: 15,
      );
      String text = "10";
      return Text(text, style: style, textAlign: TextAlign.left);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Search For Historical Data',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          color: const Color(0xff232d37),
          child: Center(
              child: Column(
            children: [
              SizedBox(
                height: 20,
              ),

              SizedBox(
                width: 170,
                height: 35,
                child: ElevatedButton(
                  onPressed: () async {
                    startTime = (await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025),
                    ))!;

                    endTime = startTime;

                    setState(() {
                      print("start: $startTime");
                      print("end:  $endTime");
                    });
                  },
                  child: Text("Insert the start time"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(buttonColor)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 170,
                height: 35,
                child: ElevatedButton(
                  onPressed: () async {
                    if (startTime.day == 1 &&
                        startTime.month == 1 &&
                        startTime.year == 2000) return null;

                    endTime = (await showDatePicker(
                      context: context,
                      initialDate: startTime,
                      firstDate: startTime,
                      lastDate: DateTime(2025),
                    ))!;

                    setState(() {
                      print("start: $startTime");
                      print("end:  $endTime");
                    });
                  },
                  child: Text("Insert the end time"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(buttonColor)),
                ),
              ),
              Row(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: 300,
                  height: 40,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: maxResultController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      hintText: "Insert number of max result row",
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                FloatingActionButton(
                  onPressed: addElement,
                  tooltip: 'Add',
                  child: Icon(Icons.search),
                ),
              ]),
              SizedBox(
                height: 40,
              ),

              //if(result.length > 0 && !dynamicListBar.isEmpty)
              // dynamicListBar[0]
              Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      color: Color(0xff232d37)),
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: 60000,
                      minX: 0,
                      maxX: 31,
                      gridData: FlGridData(
                        show: true,
                      ),
                      titlesData: FlTitlesData(
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                            getTitlesWidget: leftTitleWidgets,
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                            color: const Color(0xff37434d), width: 1),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: addResultToGraph(),
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          barWidth: 4,
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: gradientColors
                                  .map((color) => color.withOpacity(0.3))
                                  .toList(),
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          )),
        ));
  }
}
