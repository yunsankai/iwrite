import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unipus_iwrite/utils/iwrite_theme.dart';

/// @Author: cuishuxiang
/// @Date: 2022/1/13 3:04 下午
/// @Description: 选择

/// 回调：[ChooseIdentifyCallback]

typedef ChooseIdentifyCallback = void Function(int index, String identify);

class ChooseIdentify extends StatefulWidget {
  ChooseIdentifyCallback? callBack;
  String? defaultChooseStr;

  ChooseIdentify({Key? key, this.callBack, this.defaultChooseStr})
      : super(key: key);

  @override
  _ChooseIdentifyState createState() => _ChooseIdentifyState();
}

class _ChooseIdentifyState extends State<ChooseIdentify> {
  final String _middleSchoolWrite = "初中写作";
  final String _middleSchool = "初中";
  var _chooseMiddle = false;

  final String _highSchoolWrite = "高中写作";
  final String _highSchool = "高中";

  var _chooseHigh = false;

  final String _commonWrite = "通用写作";
  final String _common = "通用";

  var _chooseCommon = false;

  @override
  void initState() {
    super.initState();
    if (widget.defaultChooseStr != null &&
        widget.defaultChooseStr!.length != 0) {
      if (widget.defaultChooseStr!.contains(_middleSchool)) {
        _chooseMiddle = true;
        _chooseHigh = false;
        _chooseCommon = false;
      } else if (widget.defaultChooseStr!.contains(_highSchool)) {
        _chooseMiddle = false;
        _chooseHigh = true;
        _chooseCommon = false;
      } else if (widget.defaultChooseStr!.contains(_common)) {
        _chooseMiddle = false;
        _chooseHigh = false;
        _chooseCommon = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ElevatedButton(
            onPressed: () {
              setState(() {
                _chooseMiddle = true;
                _chooseHigh = false;
                _chooseCommon = false;
                widget.callBack?.call(0, _middleSchool);
              });
            },
            child: Text(
              _middleSchoolWrite,
              style:
                  _chooseMiddle ? _selectedTextStyle() : _unselectedTextStyle(),
            ),
            style: _chooseMiddle
                ? _selectedButtonShape()
                : _unselectedButtonShape()),
        SizedBox(
          height: 25,
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _chooseMiddle = false;
                _chooseHigh = true;
                _chooseCommon = false;
                widget.callBack?.call(1, _highSchool);
              });
            },
            child: Text(
              _highSchoolWrite,
              style:
                  _chooseHigh ? _selectedTextStyle() : _unselectedTextStyle(),
            ),
            style: _chooseHigh
                ? _selectedButtonShape()
                : _unselectedButtonShape()),
        SizedBox(
          height: 25,
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _chooseMiddle = false;
                _chooseHigh = false;
                _chooseCommon = true;
                widget.callBack?.call(2, _common);
              });
            },
            child: Text(
              _commonWrite,
              style:
                  _chooseCommon ? _selectedTextStyle() : _unselectedTextStyle(),
            ),
            style: _chooseCommon
                ? _selectedButtonShape()
                : _unselectedButtonShape()),
        SizedBox(
          height: 25,
        ),
        Divider(
          height: 0.5,
          color: iWriteTheme.FFE1E6F0,
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              height: 34,
              child: Text(
                "取消",
                style: TextStyle(fontSize: 16, color: iWriteTheme.B8262217),
              ),
            ),
          ),
        )
      ],
    );
  }

  //选中 - 按钮样式
  _selectedButtonShape() {
    return ButtonStyle(
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(const Radius.circular(25)))),
      backgroundColor: MaterialStateProperty.all(iWriteTheme.bgBlue),
      padding:
          MaterialStateProperty.all(const EdgeInsets.only(top: 10, bottom: 10)),
    );
  }

  //未选中 - 按钮样式
  _unselectedButtonShape() {
    return ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(const Radius.circular(25)))),
        backgroundColor: MaterialStateProperty.all(iWriteTheme.FFF5F7FA),
        padding: MaterialStateProperty.all(
            const EdgeInsets.only(top: 10, bottom: 10)),
        elevation: MaterialStateProperty.all(0));
  }

  _selectedTextStyle() {
    return const TextStyle(fontSize: 18, color: Colors.white);
  }

  _unselectedTextStyle() {
    return const TextStyle(fontSize: 18, color: Colors.black);
  }
}
