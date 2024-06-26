import 'dart:convert';
import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_anal/models/stock_price.dart';
import 'package:stock_anal/models/stock_prob.dart';
import 'package:stock_anal/widget/chart.dart';
import 'package:stock_anal/widget/pie_chart.dart';
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

      stocks = items;
    } catch (error) {}
  }

  Future<void> _getProbs(String title) async {
    String baseUrl = "http://192.168.0.5:3000/stocks/probs/$title";
    final response = await http.get(Uri.parse(baseUrl));
    final result = Map<String, dynamic>.of(jsonDecode(response.body));
    final List<dynamic> rawList = result["data"];

    for (final item in rawList) {
      final double? baseAndConversionNarrowStatus =
          double.tryParse(item["Base and Conversion Narrow Status"].toString());
      final double? leadingSpanTailDirection =
          double.tryParse(item["Leading Span Tail Direction"].toString());
      final double? a120dayCrossMaCheck =
          double.tryParse(item["120day cross MA Check"].toString());
      final double? a20dayCrossMaCheck =
          double.tryParse(item["20day cross MA Check"].toString());
      final double? conversionXBaseLine =
          double.tryParse(item["Conversion x Base line"].toString());
      final double? bongXBaseAndConversion =
          double.tryParse(item["Bong x Base and Conversion"].toString());
      final double? bongAndCloudStatus =
          double.tryParse(item["Bong and Cloud Status"].toString());
      final double? a5dayCrossMaCheck =
          double.tryParse(item["5day cross MA Check"].toString());
      final double? a60DaysMaTrend =
          double.tryParse(item["60 days MA Trend"].toString());
      final double? a60dayCrossMaCheck =
          double.tryParse(item["60day cross MA Check"].toString());
      final double? a9dayHighestPriceTrend =
          double.tryParse(item["9day Highest Price Trend"].toString());
      final double? a10dayCrossMaCheck =
          double.tryParse(item["10day cross MA Check"].toString());
      final double? macdStatus =
          double.tryParse(item["MACD Status"].toString());
      final double? baseAndConversionNarrowStatusLagging = double.tryParse(
          item["Base and Conversion Narrow Status (for Lagging)"].toString());
      final double? a26dayHighestPriceTrend =
          double.tryParse(item["26day Highest Price Trend"].toString());
      final double? laggingSpanXBaseAndConversion = double.tryParse(
          item["Lagging Span x Base and conversion"].toString());
      final double? laggingSpanXBong =
          double.tryParse(item["Lagging Span x Bong"].toString());
      final stockProb = StockProb(
        BaseandConversionNarrowStatus: baseAndConversionNarrowStatus ?? 0,
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

      selectedStock = stockProb;
    }
  }

  Future<void> _getStock(String title) async {
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
        _stockDatas = datas;
      }
    } catch (error) {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
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
                            onChanged: (value) async {
                              selectedValue = value;

                              await _getStock(selectedValue!);
                              await _getProbs(selectedValue!);
                              setState(() {});
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
                                return item.value
                                    .toString()
                                    .contains(searchValue);
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
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
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
          child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                PieChartSample2(
                  title: "Base and Conversion Narrow Status",
                  percentage: selectedStock != null
                      ? selectedStock!.Base_and_Conversion_Narrow_Status
                      : 0,
                ),
                PieChartSample2(
                  title: "Leading Span Tail Direction",
                  percentage: selectedStock != null
                      ? selectedStock!.BaseandConversionNarrowStatus
                      : 0,
                ),
                PieChartSample2(
                  title: "120day cross MA Check",
                  percentage: selectedStock != null
                      ? selectedStock!.Bong_and_Cloud_Status
                      : 0,
                ),
                PieChartSample2(
                    title: "20day cross MA Check",
                    percentage: selectedStock != null
                        ? selectedStock!.Bong_x_Base_and_Conversion
                        : 0),
                PieChartSample2(
                    title: "Conversion x Base line",
                    percentage: selectedStock != null
                        ? selectedStock!.Conversion_x_Base_line
                        : 0),
                PieChartSample2(
                    title: "Bong x Base and Conversion",
                    percentage: selectedStock != null
                        ? selectedStock!.Lagging_Span_x_Base_and_conversion
                        : 0),
                PieChartSample2(
                    title: "Bong and Cloud Status",
                    percentage: selectedStock != null
                        ? selectedStock!.Lagging_Span_x_Bong
                        : 0),
                PieChartSample2(
                    title: "5day cross MA Check",
                    percentage: selectedStock != null
                        ? selectedStock!.Leading_Span_Tail_Direction
                        : 0),
                PieChartSample2(
                    title: "60 days MA Trend",
                    percentage:
                        selectedStock != null ? selectedStock!.MACD_Status : 0),
                PieChartSample2(
                    title: "60day cross MA Check",
                    percentage: selectedStock != null
                        ? selectedStock!.a10day_cross_MA_Check
                        : 0),
                PieChartSample2(
                    title: "9day Highest Price Trend",
                    percentage: selectedStock != null
                        ? selectedStock!.a120day_cross_MA_Check
                        : 0),
                PieChartSample2(
                    title: "10day cross MA Check",
                    percentage: selectedStock != null
                        ? selectedStock!.a20day_cross_MA_Check
                        : 0),
                PieChartSample2(
                    title: "MACD Status",
                    percentage: selectedStock != null
                        ? selectedStock!.a26day_Highest_Price_Trend
                        : 0),
                PieChartSample2(
                    title: "Base and Conversion Narrow Status (for Lagging)",
                    percentage: selectedStock != null
                        ? selectedStock!.a5day_cross_MA_Check
                        : 0),
                PieChartSample2(
                    title: "26day Highest Price Trend",
                    percentage: selectedStock != null
                        ? selectedStock!.a60_days_MA_Trend
                        : 0),
                PieChartSample2(
                    title: "Lagging Span x Base and conversion",
                    percentage: selectedStock != null
                        ? selectedStock!.a60day_cross_MA_Check
                        : 0),
                PieChartSample2(
                    title: "Lagging Span x Bong",
                    percentage: selectedStock != null
                        ? selectedStock!.a9day_Highest_Price_Trend
                        : 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
