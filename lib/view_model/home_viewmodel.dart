import 'package:unipus_iwrite/api/api_home.dart';
import 'package:unipus_iwrite/base/base_viewmodel.dart';
import 'package:unipus_iwrite/models/write_type_home_model.dart';
import 'package:unipus_iwrite/user/UserManager.dart';
import 'package:unipus_iwrite/utils/logger_util.dart';

class HomeViewModel extends BaseViewModel {
  final String _TAG = "HomeViewModel ";

  @override
  void dispose() {
    super.dispose();
  }

  //用户 -登录，提交
  void submitUserWritType(int writeType) async {
    if (!UserManager().isLogin()) {
      XLog.e(message: "_submitUserWritType ， 用户未登录", tag: _TAG);
      return;
    }

    if (UserManager().auth == null) {
      XLog.e(message: "UserManager().auth==null", tag: _TAG);
      return;
    }

    String userId = UserManager().auth!.userId.toString();

    WriteModel writeModel = WriteModel(userId, writeType);

    var result = await ApiHome.submitWriteType(writeModel);
    UserManager().auth!.writeType = writeType;
    XLog.d(
        message: "_submitUserWritType ， result = ${result.toString()}",
        tag: _TAG);
  }
}
