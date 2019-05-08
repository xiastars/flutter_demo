import 'package:flutter/material.dart';

class CountDownDialog extends StatefulWidget {
  ValueChanged callback;

  CountDownDialog({this.callback});

  @override
  State<StatefulWidget> createState() {
    return CountDownState();
  }
}

class CountDownState extends State<CountDownDialog> {
  int count = 1;

  @override
  void initState() {
    super.initState();
    startCount(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      child: new Material(
        color: Colors.transparent,
        child: Text(
          count.toString(),
          style: TextStyle(color: Colors.red, fontSize: 100),
        ),
      ),
    );
  }

  void startCount(BuildContext context) {
    Future.delayed(new Duration(seconds: 1), () {
      // sportLine.startAnim();
      count++;
      setState(() {});
    }).then((v) {
      if (count == 3) {
        Future.delayed(new Duration(seconds: 1), () {
          Navigator.pop(context);
          widget.callback(0);
        });

        return;
      }
      startCount(context);
    });
  }
}
