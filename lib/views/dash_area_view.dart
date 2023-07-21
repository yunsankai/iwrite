import 'package:flutter/material.dart';


class DashArea extends StatefulWidget {
  //总体size
  final Size size;
  //留白size
  final Size contentSize;
  //留白偏移
  final Offset contentOffset;
  const DashArea(this.size,{Key? key,this.contentSize = Size.zero,this.contentOffset = Offset.zero}) : super(key: key);

  @override
  _DashAreaState createState() => _DashAreaState();
}

class _DashAreaState extends State<DashArea> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: DashAreaPainter(
        contentOffset: widget.contentOffset,
        contentSize: widget.contentSize,
      ),
    );
  }
}


class DashAreaPainter extends CustomPainter {
  Paint _paint = Paint()
    ..color = Color(0x99000817)
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true;

  Size? contentSize;
  Offset? contentOffset;

  DashAreaPainter({
    this.contentSize,
    this.contentOffset,
  });


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, contentOffset!.dx, size.height), _paint);
    canvas.drawRect(Rect.fromLTWH(contentOffset!.dx, 0, contentSize!.width, contentOffset!.dy), _paint);
    canvas.drawRect(Rect.fromLTWH(contentOffset!.dx+contentSize!.width, 0, size.width-contentOffset!.dx-contentSize!.width, size.height), _paint);
    canvas.drawRect(Rect.fromLTWH(contentOffset!.dx, contentOffset!.dy+contentSize!.height, contentSize!.width, size.height-contentOffset!.dy-contentSize!.height), _paint);
  }}