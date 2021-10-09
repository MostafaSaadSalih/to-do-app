// Flutter imports:
import 'package:flutter/material.dart';
import 'package:getx_project/models/task.dart';
import 'package:google_fonts/google_fonts.dart';

import '../size_config.dart';

class TaskTile extends StatelessWidget {
  const TaskTile(
    this.task, {
    Key? key,
  }) : super(key: key);
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenHeight(
            SizeConfig.orientation == Orientation.landscape ? 3.0 : 20.0),
      ),
      margin: EdgeInsets.only(bottom:getProportionateScreenHeight(12) ),
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: _backgroundColor(task.color),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title!,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time_outlined),
                        SizedBox(width: 5),
                        Text(
                          '${task.startTime!} - ${task.endTime}',
                          style: GoogleFonts.lato(
                            color: Colors.grey[100],
                            textStyle: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${task.note}',
                      style: GoogleFonts.lato(
                        color: Colors.grey[100],
                        textStyle: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 65,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.5),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted == 0 ? 'To Do' : 'Completed',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _backgroundColor(int? color) {
    switch (color) {
      case 0:
        return Color(0xffC0392B);
      case 1:
        return Color(0xffDC7633);
      case 2:
        return Colors.deepPurpleAccent;
    }
  }
}
