import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unipus_iwrite/api/api_correct.dart';
import 'package:unipus_iwrite/api/api_manual_input.dart';
import 'package:unipus_iwrite/base/base_viewmodel.dart';
import 'package:unipus_iwrite/models/base_response.dart';
import 'package:unipus_iwrite/models/correctInfo.dart';
import 'package:unipus_iwrite/models/manual_model.dart';
import 'package:unipus_iwrite/user/UserManager.dart';
import 'package:unipus_iwrite/utils/logger_util.dart';
import 'package:unipus_iwrite/utils/sp_utils.dart';
import 'package:unipus_iwrite/utils/toast_util.dart';
import 'package:unipus_iwrite/utils/tourist_uid_util.dart';

class ErrorWordModel {
  late GlobalKey key;
  late String word;
  late double offset;
  late bool isSelected;
  late ErrorList errorListModel;
  late Map position; // 句子中的位置

  ErrorWordModel(
      {required this.key,
      required this.word,
      required this.position,
      this.offset = 0,
      this.isSelected = false,
      required this.errorListModel});
}

class CorrectResultViewModel extends BaseViewModel {
  // bool isCorrecting = false;

  // bool isShowResultPage = true;

  List<ErrorWordModel> errorWords = [];

  // List<GlobalKey> errorWordKeys = [GlobalKey(),GlobalKey()];
  // List<String> errorWords = ["themselves", "future"];
  // List<double> errorOffsets = [0, 0];

  String currentWord = "";
  int currentWordIdx = 0;
  int currentSuggestionIdx = 0; // 修改建议所在位置。
  bool allWordIsSelected = false; // 是否所有的都被选
  bool isSelectedWord = false; // 是否有一个被选
  CorrectInfo? correctInfo;

  int requestTime = 0;

  CorrectResultViewModel() {
    print("CorrectResultViewModel 初始化");
  }
  @override
  dispose() {
    super.dispose();
    print("CorrectResultViewModel 被释放");
  }


  requestCorrectResult(
      State ctx, taskStudentId, int tryTime, Function needShowPerfect) async {
    this.refreshRequestState(LoadingStateEnum.LOADING, ctx, loadingBg: true);

    var result = await ApiCorrect.getCorrectInfo(taskStudentId, this.cancelToken);
    if (result.isSuccess) {
      try {
        this.correctInfo = CorrectInfo.fromJson(result.data);
        var pigaiStatus = this.correctInfo?.correctDetails!.pigaiStatus;
        if (pigaiStatus == 1) {
          if(requestTime < tryTime){
            this.refreshRequestState(LoadingStateEnum.LOADING, ctx, loadingBg: false);
            Future.delayed(Duration(milliseconds: 3000), (){
              requestTime++;
              this.requestCorrectResult(
                  ctx, taskStudentId, tryTime, needShowPerfect);
            });
          }else {
            this.refreshRequestState(LoadingStateEnum.ERROR, ctx);
          }
        }else{
          //重新生成 errorWords
          this.isSelectedWord = false;
          currentWordIdx = 0;
          currentSuggestionIdx = 0;
          allWordIsSelected = false;
          isSelectedWord = false;
          this.errorWords = [];

          //最后一个单词的位置，如果位置重复删除第二个，不然前端无法渲染。
          Map? lastWords;
          this.correctInfo?.errorList?.forEach((element) {
            List words = jsonDecode(element.taskStudentError!.words!);
            bool canAdd = true;
            if (lastWords != null){
              if(words.first["i"] < lastWords!["j"]){
                canAdd = false;
              }
            }
            if (canAdd){
              ErrorWordModel errorWordModel = ErrorWordModel(
                  key: GlobalKey(),
                  position: words.first,
                  word: element.content ?? "",
                  offset: 0,
                  isSelected: false,
                  errorListModel: element);
              this.errorWords.add(errorWordModel);
              lastWords = words.first;
            }
          });
          //
          //
          // errorWords.sort((a, b) =>
          //     jsonDecode(a.errorListModel.taskStudentError!.words!)
          //         .first["i"]
          //         .compareTo(jsonDecode(b.errorListModel.taskStudentError!.words!)
          //             .first["i"]));
          if (errorWords.length == 0) {
            allWordIsSelected = true;
            needShowPerfect();
          }
          this.refreshRequestState(LoadingStateEnum.IDLE, ctx);
        }

      } catch (e) {
        this.correctInfo = null;
        this.refreshRequestState(LoadingStateEnum.ERROR, ctx);
      }
    } else {
      this.refreshRequestState(LoadingStateEnum.ERROR, ctx);
    }
    // isCorrecting = false;
    update();
    Future.delayed(Duration(milliseconds: 200), () {
      for (var i = 0; i < errorWords.length; ++i) {
        var errorWord = errorWords[i];
        RenderBox? renderBox =
            errorWord.key.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null){
          var offset1 = renderBox.localToGlobal(Offset.zero);
          print("偏移量$offset1");
          errorWord.offset = offset1.dy;
        }
      }
    });
  }

  //更新当前单词
  // updateCurrentWord(ErrorWordModel wordModel) async {
  //   // await Future.delayed(Duration(seconds: 1));
  //   if (currentWord != wordModel.word){
  //     currentWord = wordModel.word;
  //     currentWordIdx = this.errorWords.indexOf(wordModel);
  //     update();
  //   }
  //
  // }
  //更新当前单词
  updateCurrentWordIdx(idx) async {
    // await Future.delayed(Duration(seconds: 1));
    if (currentWordIdx != idx) {
      currentWord = this.errorWords[idx].word;
      currentWordIdx = idx;
      update();
    }
  }

  //更新当前单词
  reverseWordSelected(idx) async {
    errorWords[idx].isSelected = !errorWords[idx].isSelected;
    bool allSelected = true;
    bool isSelected = false;
    for (var o in errorWords) {
      if (o.isSelected == false) {
        allSelected = false;
      } else {
        isSelected = true;
      }
    }
    isSelectedWord = isSelected;
    allWordIsSelected = allSelected;

    update();
  }

  //重新提交

  reSubmit(ctx, CorrectInfo? correctInfo, taskId, {Function(int, int)? success}) async {
    var submitText = this.correctInfoContent();
    //loading
    this.startLoading(ctx);

    int userId = -1;
    String studentName = "";

    if (UserManager().auth != null) {
      userId = UserManager().auth!.userId ?? -1;
      studentName = UserManager().auth!.userName ?? "";
    }

    //写作类型：0-通用写作;2-初中作文;1-高中作文;
    int _writeType = SpUtil.getInstance().getInt(SpUtil.KEY_WRITE_TYPE);
    if (_writeType == -1) {
      _writeType = 0;
    }
    int _addNew = 0; //1-新提交的；0-重新批改提交

    String imagePath = "";
    int _isLogin = UserManager().isLogin() ? 1 : 0;

    String _unLoginUserId = UserManager().isLogin() ? "" : TouristUidUtil().touristUid(); //未登录状态下的userId,只在未登录下传递


    RegExp exp = RegExp(r'[\s|\.\?|\,]');
    var length = submitText.split(exp).length;

    ManualModel manualModel = ManualModel(
        _addNew,
        submitText,
        imagePath,
        _isLogin,
        submitText,
        2,
        userId,
        studentName,
        taskId,
        -1,
        _unLoginUserId,
        length,
        _writeType);

    BaseResponse result = await ApiManualInput.submitTask(manualModel, this.cancelToken);
    XLog.d(message: result.toString(), tag: "_TAG");

    if (result.code == 200) {
      XToast.show("提交成功！");
      if(success != null){
        success(result.data["taskId"], result.data["taskStudentId"]);
      }
    } else {
      XToast.showErrorToast(result.msg ?? "提交失败，请重试");
    }

    //loading
    this.stopLoading(ctx);
  }
// 返回 修改后的当前的所有文字。
  String correctInfoContent() {
    if (this.correctInfo == null) {
      return "";
    } else {
      var content = "";

      correctInfo?.sentenceList?.forEach((e){
        //将每句的错误单词 放入数组。整句拆开组合成组件。 errorPositions words位置信息的组合
        List<ErrorWordModel> errorPositions = [];
        errorWords.forEach((element) {
          if (element.errorListModel.taskStudentError!.sentenceId == e.id){
            errorPositions.add(element);
          }
        });
        // 无错误，不会执行for循环，直接添加整句
        if (errorPositions.length == 0){
          content += e.content ?? "";
        }
        var lastIdx = 0;
        for (var i = 0; i < errorPositions.length; ++i) {
          var errorWord = errorPositions[i];
          // 错误单词的前面
          var frontStr = e.content?.substring(lastIdx, errorWord.position["i"]) ?? "";
          content += frontStr;
          // 错误单词
          var middleStr = errorWord.isSelected
              ? (errorWord.errorListModel.taskStudentError!.targetWords ?? "")
              : e.content!.substring(errorWord.position["i"], errorWord.position["j"]);
          content += middleStr;
          // 最后一个，合并到后面
          if (i == errorPositions.length - 1){
            var lastStr = e.content!.substring(errorWord.position["j"]);
            content += lastStr;
          }
          lastIdx = errorWord.position["j"];
        }
      });

      return content;
    }
  }
}
