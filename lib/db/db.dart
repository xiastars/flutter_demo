
import 'package:anim_demo/bean/user_bean.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// 数据库管理
class DBManager {
  static Database db;
  static const String DB_NAME = 'balanx.db'; //数据库名称

  Future<String> start() async {

   if(db != null){
      return "down";
    }

    print("result;.llll2222");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'balanx.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db
              .execute('CREATE TABLE  ${UserConst.NAME_DB} (id INTEGER PRIMARY KEY,'
              '${UserConst.NAME} TEXT,'
              '${UserConst.BIRTH} TEXT,'
              '${UserConst.SEX} TEXT,'
              '${UserConst.WEIGHT} TEXT,'
              '${UserConst.HEIGHT} TEXT,'
              '${UserConst.TEL} TEXT,'
              '${UserConst.EMAIL} TEXT,'
              '${UserConst.CHARFIRST} TEXT,'
              '${UserConst.CREAT_TIME} TEXT)')
              .then((d) {
            print("result;.lllllllll");
          }).catchError((e) {
            print("result;.lllllllll" + e);
          }).then((s) {});

        });
    return "Done";
  }

  ///插入用户数据
  static Future<bool> insertUser(UserBean userBean) async {
    bool done = false;
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, DB_NAME);
      if (db == null || !db.isOpen) {
        db = await openDatabase(path);
      }
      return db.rawInsert(
          'INSERT INTO ${UserConst.NAME_DB} (${UserConst.NAME},'
              '${UserConst.BIRTH},'
              '${UserConst.SEX},'
              '${UserConst.WEIGHT},'
              '${UserConst.HEIGHT},'
              '${UserConst.TEL},'
              '${UserConst.EMAIL},'
              '${UserConst.CHARFIRST},'
              '${UserConst.CREAT_TIME}'
              ') VALUES (?,?,?,?,?,?,?,?,?)',
          [
            userBean.name,
            userBean.birth,
            userBean.sex,
            userBean.weight,
            userBean.height,
            userBean.tel,
            userBean.email,
            userBean.charFirst,
            userBean.createTime
          ]).then((v) {
        done = true;
        return done;
      });
    } catch (e) {
      print("Error:" + e.toString());
    }
    return false;
  }

  static Future getUsers() async {
    List<UserBean> users = List();
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, DB_NAME);
      if (db == null || !db.isOpen) {
        db = await openDatabase(path);
      }
      return db.rawQuery('SELECT * FROM ${UserConst.NAME_DB}').then((r) {
        List<Map> list = r;
        for (Map m in list) {
          UserBean userBean = new UserBean.fromJson(m);
          users.add(userBean);
        }
        return users;
      });
    } catch (e) {
      print("Error:" + e.toString());
    }
  }

}
