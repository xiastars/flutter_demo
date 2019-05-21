
import 'package:anim_demo/sqlite_demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'anim_demo.dart';
import 'db/db.dart';


///动画与canvas演示
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DBManager dbManager = DBManager();
    dbManager.start();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SqlitePage(
      ),
    );
  }
}

