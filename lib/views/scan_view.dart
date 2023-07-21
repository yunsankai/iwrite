import 'dart:math';

import 'package:flutter/material.dart';


class ScanView extends StatefulWidget {
  /// 扫描框的大小
  final Size size;

  /// 直角长度
  final double? angleLength;

  /// 直角宽度
  final double? angleWidth;

  /// 边框宽度
  final double? borderWidth;

  /// 是否显示边框
  final bool? showBorder;

  /// 扫描横线宽度
  final double? scannerWidth;

  final Animation<double>? animation;

  /// 开始动画
  final bool? startAnimation;
  const ScanView({
    Key? key,
    required this.size,
    this.angleWidth,
    this.angleLength,
    this.borderWidth,
    this.showBorder,
    this.scannerWidth,
    this.startAnimation,
    this.animation
  }) : super(key: key);

  @override
  _ScanViewState createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> with SingleTickerProviderStateMixin {
  // late final AnimationController _controller;
  // late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);
    // _animation = Tween(begin: 0.0, end: widget.size.height).animate(_controller);
    // _controller.repeat();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScanner(
      size: widget.size,
      animation: widget.animation!,
      angleLength: widget.angleLength,
      angleWidth: widget.angleWidth,
      borderWidth: widget.borderWidth,
      showBorder: widget.showBorder,
      scannerWidth: widget.scannerWidth,
      startAnimation: widget.startAnimation,
    );
  }
}

class AnimatedScanner extends AnimatedWidget {
  final Size size;

  /// 直角长度
  final double? angleLength;

  /// 直角宽度
  final double? angleWidth;

  /// 边框宽度
  final double? borderWidth;

  /// 是否显示边框
  final bool? showBorder;

  /// 扫描横线宽度
  final double? scannerWidth;

  /// 开始动画
  final bool? startAnimation;

  AnimatedScanner({
    required Animation<double> animation,
    required this.size,
    this.angleLength,
    this.angleWidth,
    this.borderWidth,
    this.showBorder,
    this.scannerWidth,
    this.startAnimation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _buildWidget(),
    );
  }

  List<Widget> _buildWidget() {
    List<Widget> widgets = [];
    CustomPaint paint = CustomPaint(
      size: size,
      painter: ScanBorderPainter(
        angleLength: angleLength,
        angleWidth: angleWidth,
        borderWidth: borderWidth,
        showBorder: showBorder,
      ),
    );
    widgets.add(paint);
    if (startAnimation!) {
      Positioned positioned = Positioned(
        top: (listenable as Animation).value,
        left: 2.5,
        right: 2.5,
        height: min(this.size.height - (listenable as Animation).value, 76),
        child: Image.asset("assets/images/scan_line.png",fit: BoxFit.fill,),
      );
      widgets.add(positioned);
    }
    return widgets;
  }
}

class ScanBorderPainter extends CustomPainter {
  Paint _paint = Paint()
    ..color = Color(0xFF3274FA)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = false;

  /// 直角长度
  double? angleLength;

  /// 直角宽度
  double? angleWidth;

  /// 边框宽度
  double? borderWidth;

  /// 是否显示边框
  bool? showBorder;

  ScanBorderPainter({
    this.angleLength,
    this.angleWidth,
    this.borderWidth,
    this.showBorder,
  });

  @override
  void paint(Canvas canvas, Size size) {

    _paint.strokeWidth = angleWidth ?? 5;
    double length = angleLength ?? 30;
    // 左上角
    canvas.drawLine(Offset(0, 0), Offset(0, length), _paint);
    canvas.drawLine(Offset(0, 0), Offset(length, 0), _paint);
    // 右上角
    canvas.drawLine(
        Offset(size.width - length, 0), Offset(size.width, 0), _paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, length), _paint);
    // 左下角
    canvas.drawLine(
        Offset(0, size.height), Offset(0, size.height - length), _paint);
    canvas.drawLine(
        Offset(0, size.height), Offset(length, size.height), _paint);
    // 右下角
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - length), _paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - length, size.height), _paint);
    // 绘制边框
    if (showBorder ?? true) {
      _paint.strokeWidth = borderWidth ?? 1;
      // 左
      canvas.drawLine(
          Offset(0, length), Offset(0, size.height - length), _paint);
      // 上
      canvas.drawLine(
          Offset(length, 0), Offset(size.width - length, 0), _paint);
      // 右
      canvas.drawLine(Offset(size.width, length),
          Offset(size.width, size.height - length), _paint);
      // 下
      canvas.drawLine(Offset(length, size.height),
          Offset(size.width - length, size.height), _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}