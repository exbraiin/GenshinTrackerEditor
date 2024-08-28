import 'package:flutter/material.dart';

class GsProgressIndicator extends StatelessWidget {
  const GsProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeCap: StrokeCap.round,
        strokeWidth: 3,
      ),
    );
  }
}
