import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unipus_iwrite/views/image_view.dart';

class StarView extends StatelessWidget {
  final int score; // 1 - 5
  final Color? color;
  final double starWidth;
  final double starHeight;
  final double fontSize;
  const StarView({Key? key, required this.score, this.color, this.starWidth=10, this.starHeight=10, this.fontSize=12}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    int totalStar = score;
    int nullStartNumber = 0;
    List<Widget> stars = [];
    for (int i = 0; i < totalStar; i++ ){
      stars.add(Padding(padding: EdgeInsets.fromLTRB(0, 0, 6, 0), child: ImageView(width: this.starWidth, height: this.starHeight, imageName: "assets/images/yellow_star.png",),));
    }
    nullStartNumber = 5 - totalStar;
    for (int i = 0; i < nullStartNumber; i++ ){
      stars.add(Padding(padding: EdgeInsets.fromLTRB(0, 0, 6, 0), child: ImageView(width: this.starWidth, height: this.starHeight, imageName: "assets/images/grey_star.png",)));
    }
    return Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: stars,
        ),
    );
  }
}