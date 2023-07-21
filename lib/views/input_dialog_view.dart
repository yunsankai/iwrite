import 'package:flutter/material.dart';

/// @Author: cuishuxiang
/// @Date: 2022/1/25 4:50 下午
/// @Description:

class InputDialog extends AlertDialog {
  InputDialog({required Widget contentWidget})
      : super(
          content: contentWidget,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.blue, width: 3)),
        );
}

double btnHeight = 60;
double borderWidth = 2;

class InputDialogContent extends StatefulWidget {
  String title;
  String cancelBtnTitle;
  String okBtnTitle;
  VoidCallback cancelBtnTap;
  VoidCallback okBtnTap;
  TextEditingController vc;
  InputDialogContent(
      {required this.title,
      this.cancelBtnTitle = "Cancel",
      this.okBtnTitle = "Ok",
      required this.cancelBtnTap,
      required this.okBtnTap,
      required this.vc});

  @override
  _InputDialogContentState createState() => _InputDialogContentState();
}

class _InputDialogContentState extends State<InputDialogContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        height: 200,
        width: 10000,
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: TextStyle(color: Colors.grey),
                )),
            Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextField(
                style: TextStyle(color: Colors.black87),
                controller: widget.vc,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    )),
              ),
            ),
            Container(
              // color: Colors.red,
              height: btnHeight,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Column(
                children: [
                  Container(
                    // 按钮上面的横线
                    width: double.infinity,
                    color: Colors.blue,
                    height: borderWidth,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        onPressed: () {
                          widget.vc.text = "";
                          widget.cancelBtnTap();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.cancelBtnTitle,
                          style: TextStyle(fontSize: 22, color: Colors.blue),
                        ),
                      ),
                      Container(
                        // 按钮中间的竖线
                        width: borderWidth,
                        color: Colors.blue,
                        height: btnHeight - borderWidth - borderWidth,
                      ),
                      FlatButton(
                          onPressed: () {
                            widget.okBtnTap();
                            Navigator.of(context).pop();
                            widget.vc.text = "";
                          },
                          child: Text(
                            widget.okBtnTitle,
                            style: TextStyle(fontSize: 22, color: Colors.blue),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
