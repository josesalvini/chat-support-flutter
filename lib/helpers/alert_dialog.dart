import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

showAlert(
  BuildContext context,
  String titulo,
  String msg,
) {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(msg),
        actions: <Widget>[
          MaterialButton(
            elevation: 5,
            textColor: Colors.blue,
            onPressed: (() => Navigator.pop(context)),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(titulo),
        content: Text(msg),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
}
