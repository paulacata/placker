import 'package:flutter/material.dart';


//classe per dibuixar els títols dels camps de les assignatura i tasques amb un format determinat
class BuildTaskText extends StatelessWidget {
  final String text;

  const BuildTaskText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }
}