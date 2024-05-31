import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_anal/models/stock_price.dart';
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
      String baseUrl = "http://192.168.0.5:3000/stocks/kospi/company";

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
      print(datas);
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
