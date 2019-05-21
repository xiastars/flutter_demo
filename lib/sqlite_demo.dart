import 'package:anim_demo/style/color.dart';
import 'package:flutter/material.dart';

import 'bean/user_bean.dart';
import 'db/db.dart';

///数据库读取DEMO
class SqlitePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SqliteWidget();
  }
}

class _SqliteWidget extends State<SqlitePage> {
  String userContent = "";

  @override
  Widget build(BuildContext context) {
    UserBean userBean = new UserBean();
    userBean.name = "xiastars";
    userBean.email = "xiastars@vip.qq.com";

    DBManager.insertUser(userBean);
     DBManager.getUsers().then((s){
       List<UserBean> users = s;
       if(users != null && users.length > 0){
         setState(() {
           userContent = "从数据库读的数据：Name:"+users[0].name+",Email:"+users[1].email;
         });
       }
     });
    return new Container(
      child: Text(userContent??="Empty",style: new TextStyle(
        color:SColors.blue_56
      ),),
    );
  }
}
