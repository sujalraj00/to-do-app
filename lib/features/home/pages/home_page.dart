import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_app/core/constants/utils.dart';
import 'package:task_app/features/home/widgets/date_selector.dart';
import 'package:task_app/features/home/widgets/task_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const HomePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My task'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.add))
          ],
        ),
        body: Column(
          children: [
            // date selector
            const DateSelector(),

            Row(
              children: [
                const Expanded(
                  child: TaskCard(
                      color: Color.fromRGBO(246, 222, 194, 1),
                      headerText: 'Hello!',
                      descriptionText: 'This is a new task'),
                ),
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                      color: strengthenColor(
                          const Color.fromRGBO(246, 222, 194, 1), 0.69),
                      shape: BoxShape.circle),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    '10:00 AM',
                    style: TextStyle(fontSize: 17),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
