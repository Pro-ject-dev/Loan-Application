import 'package:finance_user/color_and_styles.dart';
import 'package:finance_user/functions/variables.dart';
import 'package:finance_user/screen/borrower.dart';
import 'package:finance_user/screen/loan.dart';
import 'package:flutter/material.dart';

showConfirmationDialog(
    BuildContext context, String message, function, String screen) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirmation", style: TextStyle(color: first)),
        content: Text(message),
        actions: <Widget>[
          TextButton(
              child: Text('Yes', style: TextStyle(color: first)),
              onPressed: () {
                function;
                print(duplicate);
                if (screen == "Loan") {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => h_screen()));
                } else {
                  if (duplicate == "NO") {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => borrower()));
                  } else {
                    Navigator.of(context).pop();
                    showDialogue(
                      context,
                      "Info",
                      "Borrower is Already Exist",
                    );
                  }
                }
              }),
          TextButton(
            child: Text('No', style: TextStyle(color: first)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future showDialogue(BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(color: first)),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(color: first),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
