import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_anal/models/stock_price.dart';
import 'package:stock_anal/models/stock_prob.dart';
import 'package:stock_anal/widget/chart.dart';
import 'package:stock_anal/widget/price_widget.dart';

class ChartContainer extends StatefulWidget {
  const ChartContainer({super.key});

  @override
  State<ChartContainer> createState() => _ChartContainerState();
}

class _ChartContainerState extends State<ChartContainer> {
  final textEditingController = TextEditingController();
  List<StockPrice> _stockDatas = [];
  String? selectedValue;
  StockProb? selectedStock;
  List<String> stocks = [];

  List<String> selectedItems = [];
  @override
  void initState() {
    super.initState();
    _getCode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
  }

  double _getLastEndPrice() {
    if (_stockDatas.isEmpty) {
      return 0;
    }
    final lastPrice = _stockDatas.last.endPrice;
    return lastPrice;
  }

  double _getFirstEndPrice() {
    if (_stockDatas.isEmpty) {
      return 0;
    }
    final lastPrice = _stockDatas.first.endPrice;
    return lastPrice;
  }

  void _getCode() async {
    try {
      String baseUrl = "http://192.168.0.5:3000/stocks/allcompany";

      final response = await http.get(Uri.parse(baseUrl));

      List<dynamic> rawList = jsonDecode(response.body);
      List<String> items = [];
      for (final item in rawList) {
        final title = item.toString();
        items.add(title);
      }

      setState(() {
        stocks = items;
      });

      print(stocks.length);
    } catch (error) {
      print("gd");
    }
  }

  void _getProbs(String title) async {
    String baseUrl = "http://192.168.0.5:3000/stocks/probs/$title";
    final response = await http.get(Uri.parse(baseUrl));
    final result = Map<String, dynamic>.of(jsonDecode(response.body));

    final List<dynamic> rawList = result["data"];
    print(rawList);

    for (final item in rawList) {
      final double? BaseandConversionNarrowStatus =
          item["Base and Conversion Narrow Status"];
      final double? leadingSpanTailDirection =
          item["Leading Span Tail Direction"];
      final double? a120dayCrossMaCheck = item["120day cross MA Check"];
      final double? a20dayCrossMaCheck = item["20day cross MA Check"];
      final double? conversionXBaseLine = item["Conversion x Base line"];
      final double? bongXBaseAndConversion = item["Bong x Base and Conversion"];
      final double? bongAndCloudStatus = item["Bong and Cloud Status"];
      final double? a5dayCrossMaCheck = item["5day cross MA Check"];
      final double? a60DaysMaTrend = item["60 days MA Trend"];
      final double? a60dayCrossMaCheck = item["60day cross MA Check"];
      final double? a9dayHighestPriceTrend = item["9day Highest Price Trend"];
      final double? a10dayCrossMaCheck = item["10day cross MA Check"];
      final double? macdStatus = item["MACD Status"];
      final double? baseAndConversionNarrowStatus =
          item["Base and Conversion Narrow Status (for Lagging)"];
      final double? a26dayHighestPriceTrend = item["26day Highest Price Trend"];
      final double? laggingSpanXBaseAndConversion =
          item["Lagging Span x Base and conversion"];
      final double? laggingSpanXBong = item["Lagging Span x Bong"];
      final stockProb = StockProb(
        BaseandConversionNarrowStatus: BaseandConversionNarrowStatus ?? 0,
        Leading_Span_Tail_Direction: leadingSpanTailDirection ?? 0,
        a120day_cross_MA_Check: a120dayCrossMaCheck ?? 0,
        a20day_cross_MA_Check: a20dayCrossMaCheck ?? 0,
        Conversion_x_Base_line: conversionXBaseLine ?? 0,
        Bong_x_Base_and_Conversion: bongXBaseAndConversion ?? 0,
        Bong_and_Cloud_Status: bongAndCloudStatus ?? 0,
        a5day_cross_MA_Check: a5dayCrossMaCheck ?? 0,
        a60_days_MA_Trend: a60DaysMaTrend ?? 0,
        a60day_cross_MA_Check: a60dayCrossMaCheck ?? 0,
        a9day_Highest_Price_Trend: a9dayHighestPriceTrend ?? 0,
        a10day_cross_MA_Check: a10dayCrossMaCheck ?? 0,
        MACD_Status: macdStatus ?? 0,
        Base_and_Conversion_Narrow_Status: baseAndConversionNarrowStatus ?? 0,
        a26day_Highest_Price_Trend: a26dayHighestPriceTrend ?? 0,
        Lagging_Span_x_Base_and_conversion: laggingSpanXBaseAndConversion ?? 0,
        Lagging_Span_x_Bong: laggingSpanXBong ?? 0,
      );
      setState(() {
        selectedStock = stockProb;
      });
      print(selectedStock);
    }

    final List<StockPrice> datas = [];
  }

  void _getStock(String title) async {
    try {
      String baseUrl = "http://192.168.0.5:3000/stocks/info/$title";

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

      if (mounted) {
        setState(() {
          _stockDatas = datas;
        });
      }
    } catch (error) {
      print(error);
      print("에러뜸");
      if (mounted) {
        setState(() {
          _stockDatas = [];
        });
      }
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
        ],
      ),
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
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          '종목명을 입력하세요',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: stocks
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                          _getStock(selectedValue!);
                          _getProbs(selectedValue!);
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 200,
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 200,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: textEditingController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: textEditingController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: '종목명',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            return item.value.toString().contains(searchValue);
                          },
                        ),
                        //This to clear the search value when you close the menu
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            textEditingController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Text(
                "과거 데이터 기반 주가 예측(참고만 하세요) ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(width: 50),
              PriceWidget(
                lastPrice: _getLastEndPrice(),
                firstPrice: _getFirstEndPrice(),
              ),
              const SizedBox(width: 140),
              Expanded(
                child: Chart(datas: _stockDatas),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
