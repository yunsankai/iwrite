

import 'package:package_info/package_info.dart';
import 'package:unipus_iwrite/base/base_viewmodel.dart';

class ProfileAboutViewModel extends BaseViewModel {

  String version = "";

  ProfileAboutViewModel() {
    PackageInfo.fromPlatform().then((value) {
      version = value.version;

      update();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}