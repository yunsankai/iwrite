import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unipus_iwrite/utils/logger_util.dart';
class IWBounceInOutCurve extends Curve {
  const IWBounceInOutCurve._();

  factory IWBounceInOutCurve() {
    return IWBounceInOutCurve._();
  }

  @override
  double transformInternal(double t) {
    //TODO 待优化 改成二次函数会更丝滑
    var x0 = 0.4,
        x1 = 0.7,
        x2 = 0.85,
        up0 = 1.10,
        up1 = 1.008,
        down0 = 0.98;
    var ret = 0.0;
    //函数
    if (t < x0)
      ret = up0 / x0 * t;
    // ret =  -10 * t*t + 7*t;
    else if (t < x1)
      ret = up0 + (down0 - up0) / (x1 - x0) * (t - x0);
    // ret =  -3.11 * t*t + 2.42*t + 0.72;
    else if (t < x2)
      ret = down0 + (up1 - down0) / (x2 - x1) * (t - x1);
    // ret =  4.5 * t*t - 6.45*t + 3.21;
    else if (t < 1)
      ret = up1 - (up1 - 1) / (1 - x2) * (t - x2);
    // ret =  -4 * t*t + 7.1*t - 2.1;
    // logger.d("ret is " + ret.toString());
    return ret;
  }
}

class IWDrawerController extends ValueListenable<bool>{
  final ObserverList<VoidCallback> _listeners = ObserverList<VoidCallback>();
  late bool _value;
  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  @override
  bool get value => _value;


  clear(){
    _listeners.clear();
  }

  show(){
    _value = true;
    notifyListener();
  }

  dismiss(){
    _value = false;
    notifyListener();
  }

  notifyListener(){
    for (var lis in _listeners) {
      lis.call();
    }
  }
}

class IWDrawer extends StatefulWidget{
  final Widget child;
  final Widget drawer;
  final IWDrawerController? controller;
  const IWDrawer({Key? key, required this.child, required this.drawer, this.controller}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _IWDrawerState();
  }

}


class _IWDrawerState extends State<IWDrawer> with TickerProviderStateMixin{

  double _panStartX = 0;
  double _leftSpace = ScreenUtil().screenWidth;
  double _panStartLeftSpace = 100;
  bool _drawerShow = false;
  bool _isPanning = false;
  double _panDownX = 0;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if(widget.controller != null){
      widget.controller!.addListener(() {
        this.setState(() {
          _drawerShow = widget.controller!.value;
          this.resetDrawerStatus();
        });
      });
    }

    _animationController = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 600), reverseDuration: const Duration(milliseconds: 300));
    CurvedAnimation lpCurvedAnimation = CurvedAnimation(
        parent: _animationController, curve: IWBounceInOutCurve(), reverseCurve: Curves.linear);
    _animation = new Tween(begin: ScreenUtil().screenWidth, end: 100.0).animate(lpCurvedAnimation);
  }

  void resetDrawerStatus(){
    if (_drawerShow){
      _leftSpace = 100;
      _animationController.forward();
    }else {
      _leftSpace = ScreenUtil().screenWidth;
      _animationController.reverse();
    }

  }
  void onPanDown(DragDownDetails details){
    _panDownX = details.globalPosition.dx;
  }

  void onPanStart(DragStartDetails details){
    // logger.d(_panDownX.toString() + ScreenUtil().screenWidth.toString());
    if (_drawerShow || _panDownX > ScreenUtil().screenWidth - 30){
      this.setState(() {
        _drawerShow = true;
        _isPanning = true;
        _panStartX = details.globalPosition.dx;
        _panStartLeftSpace = _leftSpace;
      });
    }

  }

  bool isAnimating(){
    return _animation.status == AnimationStatus.forward || _animation.status == AnimationStatus.reverse;
  }

  double realLeftSpace(){
    return isAnimating() ? _animation.value : _leftSpace;
  }

  double _leftSpaceRatio() {
    return ((ScreenUtil().screenWidth - realLeftSpace()) / ScreenUtil().screenWidth);
  }

  void onPanUpdate(DragUpdateDetails details){
    if(_isPanning){
      var moveX = _panDownX - details.globalPosition.dx;
      _leftSpace = -moveX + _panStartLeftSpace;
      _leftSpace = min(max(_leftSpace, 100), ScreenUtil().screenWidth);
      this.setState(() {
      });
      // logger.d("Movex is " + moveX.toString() + "leftSpace is " + _leftSpace.toString());
    }

  }

  void onPanEnd(DragEndDetails details){
    if(_isPanning){
      if (_leftSpace > ScreenUtil().screenWidth / 2.0){
        _animationController.reverse(from: ((ScreenUtil().screenWidth-_leftSpace)/ScreenUtil().screenWidth));
        _drawerShow = false;
        _leftSpace = ScreenUtil().screenWidth;
      }
      else {
        _animationController.forward(from: 0.9);
        _drawerShow = true;
        _leftSpace = 100;
      }
      this.setState(() {
      });
    }
    _isPanning = false;

  }

  void onTap(TapDownDetails details){
    if (details.globalPosition.dx < 100 && _drawerShow == true){
      this.setState(() {
        _drawerShow = false;
        this.resetDrawerStatus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: onPanDown,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      onTapDown: onTap,
      child: Stack(
        children: [
          widget.child,
          IgnorePointer(
            ignoring: !_drawerShow,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child){
                return Stack(
                  children: [
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().screenHeight,
                      color: Color.fromARGB((_leftSpaceRatio()*255.0 * 0.8).toInt(), 0, 0, 0),
                      // child: ClipRRect(
                      //   child: BackdropFilter(
                      //     filter: ImageFilter.blur(sigmaX: _leftSpaceRatio()*6, sigmaY: _leftSpaceRatio()*6),//背景模糊化
                      //     child: Container(
                      //     ),
                      //   ),
                      // ),
                    ),
                    Positioned(
                      left: realLeftSpace(),
                      top: 0,
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().screenHeight,
                      child: widget.drawer,
                    )
                  ],

                );
              },
            )
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller != null){
      widget.controller!.clear();
    }
    _animationController.dispose();
    super.dispose();
  }


}