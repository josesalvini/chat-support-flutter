import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  final String urlLogo;

  const CustomLogo({
    super.key,
    required this.urlLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Image(image: AssetImage(urlLogo)),
          ],
        ),
      ),
    );
  }
}
