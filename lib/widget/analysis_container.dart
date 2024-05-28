import 'package:flutter/material.dart';

class AnalysisContainer extends StatelessWidget {
  const AnalysisContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
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
      child: const Row(
        children: [],
      ),
    );
  }
}
