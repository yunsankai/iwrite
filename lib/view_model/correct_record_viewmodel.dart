

import 'package:flutter/cupertino.dart';
import 'package:unipus_iwrite/api/api_record.dart';
import 'package:unipus_iwrite/base/base_viewmodel.dart';
import 'package:unipus_iwrite/models/base_response.dart';
import 'package:unipus_iwrite/models/record_model.dart';
import 'package:unipus_iwrite/utils/toast_util.dart';

class CorrectRecordViewModel extends BaseViewModel {
  List items = [];
  bool isEmpty = false;
  int pages = 1;
  bool last = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  requestRecord(State ctx) async {
    pages = 1;
    this.refreshRequestState(LoadingStateEnum.LOADING, ctx, loadingBg: true);
    BaseResponse response = await ApiRecord.getRecordList(pages);
    if (response.isSuccess) {
      this.refreshRequestState(LoadingStateEnum.IDLE, ctx);

      RecordModel recordModel = RecordModel.fromJson(response.data);
      items = [];
      for (RecordItem item in recordModel.content) {
        if (item.pigaiStatus == 2) {
          items.add(item);
        }
      }
      last = recordModel.number == recordModel.totalPages;
      if (!last) {
        //不是最后一页
        pages += 1;
      }
      if (items.length <= 0) {
        this.isEmpty = true;
      }

      update();
    } else {
      this.refreshRequestState(LoadingStateEnum.ERROR, ctx);
    }
  }

  onRefresh() async {
    pages = 1;
    BaseResponse response = await ApiRecord.getRecordList(pages);
    if (response.isSuccess) {
      RecordModel recordModel = RecordModel.fromJson(response.data);
      items = [];
      for (RecordItem item in recordModel.content) {
        if (item.pigaiStatus == 2) {
          items.add(item);
        }
      }
      last = recordModel.number == recordModel.totalPages;
      if (!last) {
        //不是最后一页
        pages += 1;
      }
      if (items.length <= 0) {
        this.isEmpty = true;
      }

      update();
    } else {
      XToast.show(response.msg);
    }
  }

  onLoading() async {
    BaseResponse response = await ApiRecord.getRecordList(pages);
    if (response.isSuccess) {
      RecordModel recordModel = RecordModel.fromJson(response.data);
      last = recordModel.number == recordModel.totalPages;
      for (RecordItem item in recordModel.content) {
        if (item.pigaiStatus == 2) {
          items.add(item);
        }
      }
      if (!last) {
        //不是最后一页
        pages += 1;
      }

      update();
    } else {
      XToast.show(response.msg);
    }
  }

}