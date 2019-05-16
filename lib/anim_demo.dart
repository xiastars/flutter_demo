import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as sky;
import 'dart:ui';

import 'package:anim_demo/count_dialog.dart';
import 'package:anim_demo/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/**
 *
 * @Description:
 * @Author: xiastars@vip.qq.com
 * @CreateDate: 2019/5/15 10:06
 */

class AnimPage extends StatefulWidget {
  bool _isFirstInit = true;

  AnimPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AnimPageState createState() => _AnimPageState();
}

class _AnimPageState extends State<AnimPage> with TickerProviderStateMixin {
  int duration = 0;
  Timer _timer;
  int countallTime = 0; //倒计时
  SportLine sportLine;
  int repeatCount = 0; //重复次数
  int curTime = 0;

  sky.Image _image;
  Path _movePath;
  Path _renderPath;
  Path _allPath;
  List pointX;
  List pointY;
  List pointXBezier;
  List pointYBezier;
  double _lenght = 0.0;
  Paint _bezierPaint;
  Paint _renderPaint;
  Paint _dotPaint;
  PathMetric _pathMetric;
  int lentype = 1;
  double len01 = 0.0;
  double len02 = 0.0;
  double len03 = 0.0;
  double len04 = 0.0;
  double len05 = 0.0;
  int time = 5000;
  int time01 = 2000;
  int time02 = 5000;
  int time03 = 2000;
  int time04 = 5000;
  bool isType2 = true;
  bool isType3 = true;
  bool isType4 = true;
  bool isType5 = true;

  bool isSecond = true;
  bool isThree = true;
  bool isFourth = true;
  bool isFifth = true;

  double mCurrentPath = 0; //当前路径的长度
  double animLength = 0; //动画长度

  List currentPosition;

  Animation<_AnimPageState> m;
  int _imgWidth = 0;

  @override
  void initState() {
    super.initState();
    print("-----------------------------------");
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = new ScreenUtil(width: 1280, height: 800)
      ..init(context);
    initActionSeri();
    if (_image == null && widget._isFirstInit) {
      widget._isFirstInit = false;
      _movePath = new Path();
      _renderPath = new Path();
      _allPath = new Path();
      pointX = new List(6);
      pointY = new List(6);
      currentPosition = new List(2);



      initPath();

      //Gradient的用法
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

      _renderPaint = new Paint()
        ..strokeWidth = ScreenUtil().setWidth(18.0)
        ..style = PaintingStyle.stroke
        ..color = Color(0xfffea224)
        ..strokeJoin = StrokeJoin.round;

      _renderPath.moveTo(pointX[0], pointY[0]);
      loadAssetImage();
      CountDownDialog countDownDialog = new CountDownDialog(
        callback: (v) => {afterFirstCountDown()},
      );

      Future.delayed(new Duration(milliseconds: 200), () {
        // sportLine.startAnim();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return countDownDialog;
            });
      }).then((v) {});
    }
    sportLine = new SportLine(context, this);

    return getAnimgWdiget();
  }

  void afterFirstCountDown() {
    sportLine.startAnim();
    _startTimer();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  Widget getAnimgWdiget() {
    return new Container(
      child: createAnimView(),
    );
  }

  /// 创建右边视图
  Widget createAnimView() {
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
  }

  void initActionSeri() {
    repeatCount = 12;
  }

  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countallTime == 0) {
        _cancelTimer();
        setState(() {});
        return;
      }
      countallTime--;
      setState(() {});
    });
  }

  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  void onAnimFinished() {
    curTime++;
    //循环播放动画直到设定次数完结
    if (curTime + 1 <= repeatCount) {
      resetAll();
      sportLine.startAnim();
    }
    setState(() {});
  }

  void resetAll() {
    _movePath = new Path();
    _renderPath = new Path();
    _allPath = new Path();
    pointX = new List(6);
    pointY = new List(6);
    currentPosition = new List(2);

    initPath();

    _renderPath.moveTo(pointX[0], pointY[0]);
    lentype = 1;
    _lenght = len01;
    isSecond = true;
    isThree = true;
    isFourth = true;
    isFifth = true;
    animLength = len01;
  }

  initPath() {
    //第一段起始点
    pointX[0] = ScreenUtil().setWidth(0);
    pointY[0] = ScreenUtil().setWidth(208.66 * 3.9);
    currentPosition[0] = pointX[0];
    currentPosition[1] = pointY[0];
    //第二段起始点
    pointX[1] = ScreenUtil().setWidth(74.66 * 3.9);
    pointY[1] = ScreenUtil().setWidth(208.66 * 3.9);
    //第三段起始点
    pointX[2] = ScreenUtil().setWidth(136.66 * 3.9);
    pointY[2] = ScreenUtil().setWidth(46 *3.9);
    //第四段起始点
    pointX[3] = ScreenUtil().setWidth(198.33 * 3.9);
    pointY[3] = ScreenUtil().setWidth(46.66 * 3.9);
    //第五段起始点
    pointX[4] = ScreenUtil().setWidth(260.0 * 3.9);
    pointY[4] = ScreenUtil().setWidth(208.66 * 3.9);
    //第一段起始点
    pointX[5] = ScreenUtil().setWidth(321.33 * 3.9);
    pointY[5] = ScreenUtil().setWidth(208.66 * 3.9);
    _dotPaint = new Paint();
    pointXBezier = new List(4);
    pointYBezier = new List(4);
    pointXBezier[0] = ScreenUtil().setWidth(78.0 * 3.9);
    pointYBezier[0] = ScreenUtil().setWidth(186.66 * 3.9);

    pointXBezier[1] = ScreenUtil().setWidth(125.0 * 3.9);
    pointYBezier[1] = ScreenUtil().setWidth(48.0 * 3.9);

    pointXBezier[2] = ScreenUtil().setWidth(210.0 * 3.9);
    pointYBezier[2] = ScreenUtil().setWidth(48.66 * 3.9);

    pointXBezier[3] = ScreenUtil().setWidth(256.66 * 3.9);
    pointYBezier[3] = ScreenUtil().setWidth(180.0 * 3.9);
  }

  ///获取Image对象
  loadAssetImage() => rootBundle.load("img/sport.png").then((bd) {
        print("time---------------");
        Uint8List uint8list = Uint8List.view(bd.buffer);
        sky.instantiateImageCodec(uint8list).then((codec) {
          codec.getNextFrame().then((frameInfo) {
            _image = frameInfo.image;
            _imgWidth = _image.width;
          });
        });
      });
}

class SportLine extends CustomPainter {
  _AnimPageState pageState;

  BuildContext _context;

  SportLine(this._context, _AnimPageState pageState) {
    this.pageState = pageState;
  }

  Canvas canvas;
  Size size;

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.size = size;
    pageState._movePath.reset();
    pageState._allPath.reset();

    pageState._allPath.moveTo(pageState.pointX[0], pageState.pointY[0]);
    pageState._allPath.lineTo(pageState.pointX[1], pageState.pointY[1]);
    pageState._allPath.cubicTo(
        pageState.pointXBezier[0],
        pageState.pointYBezier[0],
        pageState.pointXBezier[1],
        pageState.pointYBezier[1],
        pageState.pointX[2],
        pageState.pointY[2]);
    pageState._allPath.quadraticBezierTo(pageState.pointX[2],
        pageState.pointY[2], pageState.pointX[3], pageState.pointY[3]);
    pageState._allPath.cubicTo(
        pageState.pointXBezier[2],
        pageState.pointYBezier[2],
        pageState.pointXBezier[3],
        pageState.pointYBezier[3],
        pageState.pointX[4],
        pageState.pointY[4]);
    pageState._allPath.lineTo(pageState.pointX[5], pageState.pointY[5]);
    pageState._lenght = 0;

    if (pageState.lentype == 1) {
      pageState._movePath.moveTo(pageState.pointX[0], pageState.pointY[0]);
      pageState._movePath.lineTo(pageState.pointX[1], pageState.pointY[1]);
      pageState._pathMetric =
          pageState._movePath.computeMetrics(forceClosed: false).first;
      if (pageState.len01 == 0) {
        pageState.len01 = pageState._pathMetric.length;
      }
      pageState._lenght = pageState.len01;
      pageState.animLength = pageState.len01;
    } else if (pageState.lentype == 2) {
      pageState._movePath.moveTo(pageState.pointX[1], pageState.pointY[1]);
      pageState._movePath.cubicTo(
          pageState.pointXBezier[0],
          pageState.pointYBezier[0],
          pageState.pointXBezier[1],
          pageState.pointYBezier[1],
          pageState.pointX[2],
          pageState.pointY[2]);
      pageState._pathMetric =
          pageState._movePath.computeMetrics(forceClosed: false).first;
      if (pageState.len02 == 0) {
        pageState.len02 = pageState._pathMetric.length;
      }
      pageState.animLength = pageState.len02;
      if (pageState.isSecond) {
        pageState._lenght = pageState._pathMetric.length; //878
        print("start second anim" + pageState._lenght.toString());
        pageState.time = pageState.time01;
        pageState.isSecond = false;
        new Future.delayed(Duration(milliseconds: 10), () {
          print("start second anim" + pageState._pathMetric.length.toString());
          startAnim();
        });
      }
    } else if (pageState.lentype == 3) {
      pageState._movePath.moveTo(pageState.pointX[2], pageState.pointY[2]);
      pageState._movePath.quadraticBezierTo(pageState.pointX[2],
          pageState.pointY[2], pageState.pointX[3], pageState.pointY[3]);
      pageState._pathMetric =
          pageState._movePath.computeMetrics(forceClosed: false).first;
      if (pageState.len03 == 0) {
        pageState.len03 = pageState._pathMetric.length;
      }
      pageState.animLength = pageState.len03;
      if (pageState.isThree) {
        pageState._lenght =
            pageState._pathMetric.length - pageState._lenght; //878
        pageState.time = pageState.time02;
        pageState.isThree = false;
        new Future.delayed(Duration(milliseconds: 200), () {
          startAnim();
        });
      }
    } else if (pageState.lentype == 4) {
      pageState._movePath.moveTo(pageState.pointX[3], pageState.pointY[3]);
      pageState._movePath.cubicTo(
          pageState.pointXBezier[2],
          pageState.pointYBezier[2],
          pageState.pointXBezier[3],
          pageState.pointYBezier[3],
          pageState.pointX[4],
          pageState.pointY[4]);
      pageState._pathMetric =
          pageState._movePath.computeMetrics(forceClosed: false).first;
      if (pageState.len04 == 0) {
        pageState.len04 = pageState._pathMetric.length;
      }
      pageState.animLength = pageState.len04;
      if (pageState.isFourth) {
        pageState._lenght =
            pageState._pathMetric.length - pageState._lenght; //878
        pageState.time = pageState.time03;
        pageState.isFourth = false;
        new Future.delayed(Duration(milliseconds: 200), () {
          startAnim();
        });
      }
    } else if (pageState.lentype == 5) {
      pageState._movePath.moveTo(pageState.pointX[4], pageState.pointY[4]);
      pageState._movePath.lineTo(pageState.pointX[5], pageState.pointY[5]);
      pageState._pathMetric =
          pageState._movePath.computeMetrics(forceClosed: false).first;
      if (pageState.len05 == 0) {
        pageState.len05 = pageState._pathMetric.length;
      }
      pageState.animLength = pageState.len05;
      if (pageState.isFifth) {
        pageState._lenght = pageState._pathMetric.length; //878
        pageState.time = pageState.time04;
        pageState.isFifth = false;
        new Future.delayed(Duration(milliseconds: 200), () {
          startAnim();
        });
      }
    }
    canvas.drawPath(pageState._movePath, pageState._bezierPaint);
    canvas.drawPath(pageState._allPath, pageState._bezierPaint);
    canvas.drawPath(pageState._renderPath, pageState._renderPaint);
    var _image = pageState._image;
    if (_image != null) {
      Offset offset = new Offset(
          pageState.currentPosition[0] - _image.width / 2,
          pageState.currentPosition[1] - _image.height / 2);
      canvas.drawImage(_image, offset, pageState._dotPaint);
    }
  }

  @override
  bool shouldRepaint(SportLine oldDelegate) {
    /*    if (oldDelegate.currentPosition[1] != currentPosition[1]) {
              return true;
            }*/
    return true;
  }

  AnimationController _animationController;
  Animation<double> doubleAnimation;
  Animation<double> seconddoubleAnimation;

  void startAnim() {
    if (_animationController != null) {
      _animationController.dispose();
      _animationController = null;
    }
    _animationController = new AnimationController(
        vsync: pageState, duration: Duration(milliseconds: pageState.time));
    print(pageState.animLength.toString() +
        ",,,,time:" +
        pageState.time.toString());
    doubleAnimation = new Tween(begin: 0.0, end: pageState.animLength * 1.0)
        .animate(_animationController)
          ..addListener(() {
            afterAnim();
          });

    _animationController.forward(from: 0.0);
  }

  void afterAnim() {
    pageState.mCurrentPath = doubleAnimation.value;
    if (pageState.lentype == 1) {
      pageState.currentPosition[0] = pageState.mCurrentPath;
    } else if (pageState.lentype == 2 && !pageState.isSecond) {
      if (pageState._pathMetric != null) {
        Tangent tange =
            pageState._pathMetric.getTangentForOffset(pageState.mCurrentPath);
        pageState.currentPosition[0] = tange.position.dx;
        pageState.currentPosition[1] = tange.position.dy;
      }
    } else if (pageState.lentype == 3) {
      pageState.currentPosition[0] =
          pageState.pointX[2] + pageState.mCurrentPath;
    } else if (pageState.lentype == 4) {
      if (pageState._pathMetric != null) {
        Tangent tange =
            pageState._pathMetric.getTangentForOffset(pageState.mCurrentPath);
        pageState.currentPosition[0] = tange.position.dx;
        pageState.currentPosition[1] = tange.position.dy;
      }
    } else if (pageState.lentype == 5) {
      pageState.currentPosition[0] =
          pageState.pointX[4] + pageState.mCurrentPath;
    }
    pageState._renderPath
        .lineTo(pageState.currentPosition[0], pageState.currentPosition[1]);
    //第二段 上升
    if (pageState.lentype == 1 && pageState.mCurrentPath == pageState.len01) {
      pageState.lentype = 2;
      if (pageState.isType2) {
        pageState.isType2 = !pageState.isType2;
      }
      print("the first anim is ending");
      pageState._lenght = pageState.len02;
    } else if (pageState.lentype == 2 &&
        pageState.mCurrentPath == pageState.len02) {
      pageState.lentype = 3;
    } else if (pageState.lentype == 3 &&
        pageState.mCurrentPath == pageState.len03) {
      pageState.lentype = 4;
      pageState._lenght = pageState.len04;
    } else if (pageState.lentype == 4 &&
        pageState.mCurrentPath == pageState.len04) {
      pageState.lentype = 5;
      pageState._lenght = pageState.len05;
    } else if (pageState.lentype == 5 &&
        pageState.mCurrentPath == pageState.len05) {
      //最终结束动画
      pageState.onAnimFinished();
    }
    pageState.setState(() {});
  }
}
