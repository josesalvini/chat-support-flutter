import 'package:flutter/material.dart';

class CustomLabelFooter extends StatelessWidget {
  final String question;
  final String action;
  final String route;

  const CustomLabelFooter({
    super.key,
    required this.route,
    required this.question,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        children: <Widget>[
          Text(
            question,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, route);
            },
            child: Text(action,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[600],
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
