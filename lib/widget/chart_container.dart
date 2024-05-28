import 'package:flutter/material.dart';
import 'package:stock_anal/widget/chart.dart';
import 'package:stock_anal/widget/price_widget.dart';

class ChartContainer extends StatelessWidget {
  const ChartContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "지금이니!?",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                ),
              ),
              SearchBar(
                padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 15),
                ),
                overlayColor: MaterialStatePropertyAll(Colors.transparent),
                hintText: "종목을 검색하세요.",
                hintStyle: MaterialStatePropertyAll(TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
                shadowColor: MaterialStatePropertyAll(Colors.transparent),
                trailing: <Widget>[
                  Icon(
                    Icons.search,
                  )
                ],
              )
            ],
          ),
          Row(
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
          SizedBox(height: 50),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  SizedBox(width: 50),
                  PriceWidget(),
                ],
              ),
              SizedBox(width: 140),
              Expanded(child: Chart()),
            ],
          ),
        ],
      ),
    );
  }
}
