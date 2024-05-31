import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stock_anal/models/stock_price.dart';
import 'package:stock_anal/widget/chart.dart';
import 'package:stock_anal/widget/price_widget.dart';
import 'package:http/http.dart' as http;

class ChartContainer extends StatefulWidget {
  const ChartContainer({super.key});

  @override
  State<ChartContainer> createState() => _ChartContainerState();
}

class _ChartContainerState extends State<ChartContainer> {
  final _controller = TextEditingController();
  List<StockPrice> _stockDatas = [];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _getStock(String title) async {
    try {
      String baseUrl = "http://localhost:3000/stocks/info/$title";

      // HTTP 요청을 보냅니다.
      final response = await http.get(Uri.parse(baseUrl));
      final result = Map<String, dynamic>.of(jsonDecode(response.body));
      final rawList = result["data"];
      final List<StockPrice> datas = [];
      for (final item in rawList) {
        final stock = Map<String, dynamic>.of(item);
        final stockPrice = StockPrice(
          id: stock["_id"].toString(),
          date: DateTime.parse(stock["날짜"].toString()),
          endPrice: double.parse(stock["종가"].toString()),
          lowPrice: double.parse(stock["저가"].toString()),
          highPrice: double.parse(stock["고가"].toString()),
        );
        datas.add(stockPrice);
      }

      setState(() {
        _stockDatas = datas;
      });

      print(datas);
    } catch (error) {
      print(error);
      print("에러뜸");
      _stockDatas = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 0.5,
              offset: const Offset(3, 3),
            )
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "지금이니!?",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: SearchBar(
                      controller: _controller,
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 15),
                      ),
                      overlayColor:
                          const MaterialStatePropertyAll(Colors.transparent),
                      hintText: "종목을 검색하세요.",
                      hintStyle: const MaterialStatePropertyAll(TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                      shadowColor:
                          const MaterialStatePropertyAll(Colors.transparent),
                      trailing: [
                        GestureDetector(
                          child: const Icon(Icons.search),
                          onTap: () {
                            final title = _controller.text;
                            _getStock(title);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Row(
            children: [
              Text(
                "과거 데이터 기반 주가 예측(참고만 하세요) ",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              )
            ],
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Row(
                children: [
                  SizedBox(width: 50),
                  PriceWidget(),
                ],
              ),
              const SizedBox(width: 140),
              Expanded(child: Chart(datas: _stockDatas)),
            ],
          ),
        ],
      ),
    );
  }
}
