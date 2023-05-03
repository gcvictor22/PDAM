import 'package:flutter/cupertino.dart';

class Gender {
  late int id;
  late String name;
  IconData icon;
  bool isSelected;

  Gender(
      {required this.id,
      required this.name,
      required this.icon,
      required this.isSelected});
}
