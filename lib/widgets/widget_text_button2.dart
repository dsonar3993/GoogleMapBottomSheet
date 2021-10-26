import 'package:flutter/material.dart';

class WidgetTextButtonActivate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: TextButton(
        child: Container(
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.blue),
            
          ),
          child: Text("ACTIVATE", style: TextStyle(color: Colors.blue,fontSize: 10)),
        ),
        onPressed: () => {},
      ),
    );
  }
}
