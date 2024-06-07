// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:stock_anal/models/stock_prob.dart';
// import 'package:stock_anal/widget/pie_chart.dart';

// class AnalysisContainer extends StatefulWidget {
//   const AnalysisContainer({super.key});

//   @override
//   State<AnalysisContainer> createState() => _AnalysisContainerState();
// }

// class _AnalysisContainerState extends State<AnalysisContainer> {
//   StockProb? selectedStock;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.3,
//       width: double.infinity,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.7),
//               blurRadius: 0.5,
//               offset: const Offset(3, 3),
//             )
//           ]),
//       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
//       child: ScrollConfiguration(
//         behavior: MyCustomScrollBehavior(),
//         child: ListView(
//           scrollDirection: Axis.horizontal,
//           children: const [
//             PieChartSample2(),
//             PieChartSample2(),
//             PieChartSample2(),
//             PieChartSample2(),
//             PieChartSample2(),
//             PieChartSample2(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MyCustomScrollBehavior extends MaterialScrollBehavior {
//   // Override behavior methods and getters like dragDevices
//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//         PointerDeviceKind.touch,
//         PointerDeviceKind.mouse,
//         // etc.
//       };
// }
