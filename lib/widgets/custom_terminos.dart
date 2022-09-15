import 'package:flutter/material.dart';

class CustomTerminosCondiciones extends StatelessWidget {
  const CustomTerminosCondiciones({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: const Text('Terminos y Condiciones de uso',
          style: TextStyle(fontWeight: FontWeight.w400)),
    );
  }
}
