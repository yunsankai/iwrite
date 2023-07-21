import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String imageName;
  final double width;
  final double height;
  final Widget? child;
  const ImageView({Key? key, required this.imageName, required this.width, required this.height, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(width: width, height: height,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(imageName), fit: BoxFit.fitWidth)
      ), child: child,);

  }
}