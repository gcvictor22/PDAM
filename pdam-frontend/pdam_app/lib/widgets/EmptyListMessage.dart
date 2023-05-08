import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

class EmptyListMessage extends StatelessWidget {
  final String message;
  const EmptyListMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: BlurryContainer(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        width: double.infinity,
        padding: EdgeInsets.all(20),
        color: const Color.fromARGB(255, 193, 193, 193).withOpacity(0.35),
        blur: 8,
        elevation: 6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
            Image.asset(
              "assets/404.gif",
              scale: 4,
            ),
          ],
        ),
      ),
    );
  }
}
