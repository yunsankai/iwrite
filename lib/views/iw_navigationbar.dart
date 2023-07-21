import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unipus_iwrite/route/navigator_util.dart';
import 'package:unipus_iwrite/route/route_config.dart';
import 'package:unipus_iwrite/utils/iwrite_theme.dart';

class IWNavigationBar extends StatefulWidget{
  final String title;

  const IWNavigationBar({Key? key, required this.title}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _IWNavigationBarState();
  }
  static double navigationBarHeight(){
    return ScreenUtil().statusBarHeight + 54;
  }
}

class _IWNavigationBarState extends State<IWNavigationBar>{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: IWNavigationBar.navigationBarHeight(),
      width: ScreenUtil().screenWidth,
      color: Colors.black,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(widget.title, style: iWriteTheme.headline,),
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            actions: [
            ],
            floating: false,
          )
        ],
      ),
    );
  }

}