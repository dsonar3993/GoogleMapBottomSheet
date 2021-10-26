import 'package:flutter/material.dart';

class WidgetTextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: TextButton(
        child: Container(
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.blue,
          ),
          child: Text("BOOK", style: TextStyle(color: Colors.white,fontSize: 10)),
        ),
        onPressed: () => {},
      ),
    );
  }
}
