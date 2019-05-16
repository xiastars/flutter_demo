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

### 5. no device
需要配置android-sdk 和android-studio环境 
```
flutter config --android-sdk your path
flutter coig --android-studio-dir your path
```


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

### 4.Gradient的使用
A.用在Paint上
```
      var gradient = sky.Gradient.linear(Offset(0, 0),Offset(ScreenUtil().setWidth(321.33 * 3.9), 0),
         [SColors.red_51, SColors.blue_56, SColors.red_oa,SColors.blue_56],
         [0.1, 0.5, 0.7, 0.9]//每种颜色的区域,
      );
      _bezierPaint = new Paint()
        ..strokeWidth = ScreenUtil().setWidth(18.0)
        ..style = PaintingStyle.stroke
        ..color = Color(0xff422117)
        ..strokeJoin = StrokeJoin.round
        ..shader = gradient;
```
B.用在Widget上
```
    var myIndigoGradient = LinearGradient(
      // Where the linear gradient begins and ends
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      // Add one stop for each color. Stops should increase from 0 to 1
      stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        Colors.yellow[900],
        Colors.yellow[700],
        Colors.yellow[600],
        Colors.yellow[400],
      ],
    );
    return new Container(
      decoration: new BoxDecoration(
        gradient: myIndigoGradient,
      ),
      alignment: Alignment.centerLeft,
      child: new CustomPaint(painter: sportLine, willChange: false),
    );
```
### 5.CustomPainter的使用

```
//指定一条线的path
path.moveTo(x,y);
path.lineTo(x1,y1);
//指定一条曲线的path,x1,y1,x2,y2为控制点，x3.y3为到达点
path.cubicTo(x1,y1,x2,y2,x3,y3);
//从起始点到x2,y2的二次曲线，以x1,y1为控制点
path.quadraticBezierTo(x1,y1,x2,y2);
//测量曲线长度
pathMetric = path.computeMetrics(forceClosed:false).first;
length = pathMetric.length;
//通过长度获取曲线的偏移位置
Tangent tangent = pathMetric.getTangentForOffset(pathLength);
x = tangent.position.dx;
y = tangent.position.dy;
//canvas画path
canvas.drawPath(path,paint);
//canvas画image
canvas.drawImage(image,offset,paint);
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

# 四.包含DEMO
### 1. anim_demo.dart
> gradient,anim,paint的 实践

![image](https://github.com/xiastars/flutter_demo/blob/master/show_file/@RIVGL7H8L%7DSEF@TJ9@3%25UR.gif?raw=true)
