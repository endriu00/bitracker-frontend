import 'dart:async';
import 'dart:core';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_project/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String apiPathCryptoHistory = 'https://9gfx4yhlgg.execute-api.us-east-2.amazonaws.com/prod/v1/history/';
  List<FlSpot> cryptoDataResult = [] ;
  
  TextEditingController maxResultController = new TextEditingController();
  HistoryPageState(this.crypto);

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a)
  ];

  Future<List<CryptoEntity>> getHistory(String cryptoName, DateTime startTime, DateTime endTime, bool spread, String maxResults) async {
    String startTimeStr = DateFormat('yyyy-MM-dd – kk:mm').format(startTime);
    String endTimeStr = DateFormat('yyyy-MM-dd – kk:mm').format(endTime);
    String spreadStr = "";
    List <CryptoEntity> cryptoData = [];
    
    if(spread) {
      spreadStr = "True";
    } else {
      spreadStr = "False";
    }

    Uri url = Uri.parse(
            apiPathCryptoHistory +
            cryptoName.toLowerCase() +
            '?start=' + "2022-04-08T08:31:00.000Z" +
            '&end=' + "2022-14-08T08:32:00.000Z" +
            '&spread=' + spreadStr +
            '&max_results=' + maxResults);
    

    var response = await http.get(
      url,
    );
    jsonDecode(response.body).forEach((element) {cryptoData.add(CryptoEntity.fromJson(element)); });
    return cryptoData;
  
  }

  Future<void> getHistoryOnPressed() async {
    List<CryptoEntity> result = [];

    result = await getHistory(crypto, startTime, endTime, true, maxResultController.text);

    result.forEach((element) => cryptoDataResult.add(new FlSpot(element.dateResult.day.toDouble(), element.price)));
    
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
                  onPressed: getHistoryOnPressed,
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
                          spots: cryptoDataResult,
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
