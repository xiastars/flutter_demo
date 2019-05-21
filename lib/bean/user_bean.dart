import 'package:json_annotation/json_annotation.dart';

class UserConst {
  static const String NAME_DB = "USER"; //表名
  static const String NAME = 'name'; //姓名
  static const String BIRTH = 'birth'; //生日
  static const String SEX = 'sex'; //性别
  static const String WEIGHT = 'weight'; //重量
  static const String HEIGHT = 'height'; //身高
  static const String TEL = 'tel'; //电话
  static const String EMAIL = 'email'; //邮件
  static const String CHARFIRST = 'char_first'; //首字母
  static const String CREAT_TIME = 'creat_time'; //创建时间
}

@JsonSerializable()
class UserBean {
  int id;
  String name;
  String birth;
  String sex;
  String weight;
  String height;
  String tel;
  String email;
  String charFirst;
  String createTime;

  UserBean(
      {this.id,
        this.name,
        this.birth,
        this.sex,
        this.weight,
        this.height,
        this.tel,
        this.email,
        this.charFirst,
        this.createTime});

  factory UserBean.fromJson(Map<String, dynamic> json) =>
      _$UserBeanFromJson(json);
}

UserBean _$UserBeanFromJson(Map<String, dynamic> json) {
  return UserBean(
      id: json['id'] as int,
      name: json['name'] as String,
      birth: json['birth'] as String,
      sex: json['sex'] as String,
      weight: json['weight'] as String,
      height: json['height'] as String,
      tel: json['tel'] as String,
      email: json['email'] as String,
      charFirst: json['charFirst'] as String,
      createTime: json['createTime'] as String);
}