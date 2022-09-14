import 'package:flutter/material.dart';

class CustomLabelHeader extends StatelessWidget {
  final String text;

  const CustomLabelHeader({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(text, style: const TextStyle(fontSize: 30)),
    );
  }
}
