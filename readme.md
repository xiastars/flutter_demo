
# 一.坑系列
### 1.更改package
要改src/debug/AndroidManifest.xml里的package

### 2.Waiting for another flutter command to release the starup lock
* 关闭studio,杀掉dart.ext进程 
* 在flutter sdk bin cache里，删掉Lock文件

### 3.安卓启动白屏
启动白屏是因为flutter冷启动得耗时几秒,在android的drawable目录下，有一个launcher_background.xml，这个就是启动时的页面，修改这个

### 4.变量写在类外
描述：有一个动画实现我用到了三个类，StatefulWidget,State,CustomPainter，为了让变量共用，我将变量写在类外，如图所示
```
int value = 1;
class XXX extends StatefulWidget{
    value = 100;
}
```
XXX被pop之后，再返回这个页面,这个value还是100，解决变法，变量写在类里面，在State里，通过widget.value来获取，创建CustomPainter时传入State，也是通过以上的方法取，最简单的做法是在StatefulWidget里定义一个方法，重置所有变量的值




# 二.边学边做

### 1. 颜色资源定义与使用
flutter自定Colors类，但是满足不了各自的设计师，定义如下：
```
class SColors {
  ///按钮主色调
  static const Color red_oa = Color(0xffd04f0f);
  ///按钮暗色调
  static const Color red_aa = Color(0xffaa4d27);
  ///按钮禁止色调
  static const Color red_51 = Color(0xff513f38);
  ///文字主色调
  static const Color grey_61cc = Color(0x61cccccc);
}
```
使用：
```
backgroundColor: SColors.red_oa
```

### 2. 页面跳转与传递数据
A界面跳转：
```
  ///跳转到躯干设置
  static void jumpToBodySetting(BuildContext context,
      {int trainingChoose, int execiseMode, int execiseOnMode}) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (__) => new BodySettingPage(
                trainingType: trainingType,
                execiseMode: execiseMode,
                execiseOnMode: execiseOnMode)));
  }
```
B界面得到数据：
```
int trainingType; 
int execiseMode; 
int execiseOnMode; 

/* 躯干调节 */
class BodySettingPage extends StatefulWidget {
  int trainingType; 
  BodySettingPage({this.trainingType, execise, execiseOnMode}){
    execiseMode = execise;
  }

  @override
  State<StatefulWidget> createState() {
    print(trainingType.toString()+",,"+execiseMode.toString()+",,"+execiseOnMode.toString());
    return new _BodySettingPageState();
  }
}
```
> 注：留意这里的赋值，execiseOnMode是没有成功赋值的

### 3.使用本地资源图片
1. 项目根目录下，与lib等级的地方建一个文件夹，比如img，图片放到此去
2. 在pubspec.yaml文件，在flutter:下定义img:
```
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  assets:
  - img/
```
> 注意间距，多一个空格就会报错

图片的使用：
```
Image.asset('img/first_logo.png',
                  width: 100.0, height: 100.0)
```


# 三.语法熟悉
### 1.给String指定默认值 
```
Text(curUserBean?.birth ?? '1980-10-10'),
//int类型
return (partPulse?.arms ?? 0).toString() + "%";
```
> ??= 的意思是如果前面的birth不为null，则取birth的值，如果为null，则取后面给的默认值 

### 2.给对象里的int类型设置默认的值 
如果你为一个对象创建了一个构造器，那么你需要在构造器里为int类型指定默认的值 
```
 PartPulseBean({this.id = 0})
```
