import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:s93task/models/task_model.dart';

class TastCard extends StatelessWidget {
  final TaskModel model;
  final int themeNo;
  final bool showDate;
  const TastCard({
    super.key,
    required this.model,
    required this.themeNo,
    required this.showDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDate == true)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              model.date ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        Card(
          elevation: 4,
          shadowColor: Colors.black,
          margin: EdgeInsets.symmetric(
            horizontal: context.width * 0.03,
            vertical: 10,
          ),
          color:
              themeNo == 0
                  ? Color.fromARGB(255, 97, 175, 167)
                  : themeNo == 1
                  ? Color.fromARGB(255, 53, 141, 132)
                  : Color.fromARGB(255, 12, 115, 105),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: context.width - (context.width * 0.03 + 15),
                  child: Text(
                    model.title ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (model.description != null) ...[
                  SizedBox(height: 5),
                  SizedBox(
                    width: context.width - (context.width * 0.03 + 15),
                    child: Text(
                      model.description ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
                SizedBox(height: 5),
                SizedBox(
                  width: context.width - (context.width * 0.03 + 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      model.time ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
