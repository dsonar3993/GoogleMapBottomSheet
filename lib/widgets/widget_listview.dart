import 'package:flutter/material.dart';
import 'widget_text_button.dart';

class WidgetListView extends StatelessWidget {
  const WidgetListView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: new List.generate(
          5,
          (index) => Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Image.asset(
                      'assets/images/scooter.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blue,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '400m',
                                style: TextStyle(
                                    color: Colors.cyan, fontSize: 12),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons
                                    .battery_charging_full_outlined),
                                Text(
                                  '40%',
                                  style: TextStyle(
                                    color: Colors.cyan,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          'Jefson E-Kick Air Electric Scooter',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  WidgetTextButton()
                ],
              )),
    );
  }
}