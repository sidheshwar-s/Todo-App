import 'dart:ffi';

import 'package:flutter/material.dart';

class TaskcardWidget extends StatelessWidget {
  final String title;
  final String body;
  TaskcardWidget({this.title, this.body});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 20,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "(No title)",
            style: TextStyle(
              color: Color(0xff211551),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Text(
              body ?? "No description",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff86829D),
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isdone;
  TodoWidget({this.text, @required this.isdone});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(
              right: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: isdone ? Color(0xff7349fe) : Colors.transparent,
              border: isdone
                  ? null
                  : Border.all(
                      color: Color(0xff86829D),
                      width: 1.5,
                    ),
            ),
            child: Image(
              image: AssetImage(
                'assets/images/check_icon.png',
              ),
            ),
          ),
          Flexible(
            child: Text(
              text ?? "(Unnamed Todo)",
              style: TextStyle(
                color: isdone ? Color(0xff211551) : Color(0xff86829D),
                fontSize: 16,
                fontWeight: isdone ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
