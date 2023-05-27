import 'package:flutter/material.dart';

class SpaceLine extends StatelessWidget {
  final Color color;
  const SpaceLine({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.5),
            color.withOpacity(0.75),
            color,
            color,
            color,
            color,
            color,
            color,
            color,
            color.withOpacity(0.75),
            color.withOpacity(0.5),
          ],
        ),
      ),
    );
  }
}
