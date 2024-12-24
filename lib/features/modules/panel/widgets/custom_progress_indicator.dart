import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: const Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: LoadingIndicator(
            indicatorType: Indicator.ballPulse,
            colors: [Colors.orangeAccent],
            strokeWidth: 6,
            backgroundColor: Colors.transparent,
            pathBackgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
