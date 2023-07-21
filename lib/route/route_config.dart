import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unipus_iwrite/base/base_viewmodel.dart';
import 'package:unipus_iwrite/scenes/correct_camera.dart';
import 'package:unipus_iwrite/scenes/correct_record.dart';
import 'package:unipus_iwrite/scenes/launch_page.dart';
import 'package:unipus_iwrite/scenes/login_page.dart';
import 'package:unipus_iwrite/scenes/result/correct_result.dart';
import 'package:unipus_iwrite/scenes/feedback_page.dart';
import 'package:unipus_iwrite/scenes/home.dart';
import 'package:unipus_iwrite/scenes/manual_input_page.dart';
import 'package:unipus_iwrite/scenes/profile_about.dart';
import 'package:unipus_iwrite/scenes/profile_account.dart';
import 'package:unipus_iwrite/scenes/profile_identity.dart';
import 'package:unipus_iwrite/scenes/profile_privacy_alert.dart';
import 'package:unipus_iwrite/scenes/profile_set.dart';
import 'package:unipus_iwrite/scenes/profile_webview.dart';
import 'package:unipus_iwrite/view_model/correct_camera_viewmodel.dart';
import 'package:unipus_iwrite/view_model/correct_record_viewmodel.dart';
import 'package:unipus_iwrite/view_model/correct_result_viewmodel.dart';
import 'package:unipus_iwrite/view_model/feedback_viewmodel.dart';
import 'package:unipus_iwrite/view_model/home_viewmodel.dart';
import 'package:unipus_iwrite/view_model/launch_viewmodel.dart';
import 'package:unipus_iwrite/view_model/manual_viewmodel.dart';
import 'package:unipus_iwrite/view_model/profile_about_viewmodel.dart';

class RouteConfig {
  static String homePage = '/';
  static String correctResultPage = "/correct/result";
  static String correctRecordPage = "/correct/record";
  static String manualInputPage = "/manual_input";
  static String profileSetPage = "/profile_set";
  static String profileAccountPage = "/profile_account";
  static String profileAboutPage = "/profile_about";
  static String feedBackPage = "/feedback_page";
  static String correctCameraPage = "/correct/camera";
  static String profileWebViewPage = "/profile_webview";
  static String profileIdentityPage = "/profile_identity";
  static String profilePrivacyAlertPage = "/profile_Privacy_alert";
  static String launchPagePath = "/launch_page";
  static final List<GetPage> getPages = [
    GetPage(
      name: launchPagePath,
      page: () => LaunchPage(),
      binding: BindingsBuilder(() => {
        Get.lazyPut(() => LaunchViewModel())
      }),
      transitionDuration: Duration(milliseconds: 0)
    ),
    GetPage(
      name: homePage,
      page: () => HomeScreen(),
      binding: BindingsBuilder(() => {
            Get.lazyPut(() => HomeViewModel())
          }),
        transitionDuration: Duration(milliseconds: 0)

    ),
    GetPage(
      name: correctResultPage,
      page: () => CorrectResult(),
      binding: BindingsBuilder(() => {
            Get.lazyPut(() {
              return CorrectResultViewModel();
            })
          }),
    ),
    GetPage(
      name: correctRecordPage,
      page: () => CorrectRecord(),
      binding:
          BindingsBuilder(() => {Get.lazyPut(() => CorrectRecordViewModel())}),
    ),

    ///手动输入
    GetPage(
      name: manualInputPage,
      page: () => ManualInputPage(),
      binding:
          BindingsBuilder(() => {Get.lazyPut(() => ManualInputViewModel())}),
      customTransition: SizeTransitions(),
      transitionDuration: Duration(milliseconds: 300),
    ),

    GetPage(
      name: profileSetPage,
      page: () => ProfileSet(),
      binding: BindingsBuilder(() => {
            // Get.lazyPut(() => CounterController())
          }),
    ),

    GetPage(
      name: profileAccountPage,
      page: () => ProfileAccount(),
      binding: BindingsBuilder(() => {
            // Get.lazyPut(() => CounterController())
          }),
    ),

    GetPage(
      name: profileAboutPage,
      page: () => ProfileAbout(),
      binding:
          BindingsBuilder(() => {Get.lazyPut(() => ProfileAboutViewModel())}),
    ),

    ///意见反馈
    GetPage(
      name: feedBackPage,
      page: () => FeedBackPage(),
      binding: BindingsBuilder(() => {Get.lazyPut(() => FeedBackViewModel())}),
    ),

    GetPage(
      name: correctCameraPage,
      page: () => CorrectCamera(),
      binding:
          BindingsBuilder(() => {Get.lazyPut(() => CorrectCameraViewModel())}),
    ),

    GetPage(
      name: profileWebViewPage,
      page: () => WebViewPage(),
      binding: BindingsBuilder(() => {}),
    ),

    GetPage(
      name: profileIdentityPage,
      page: () => ProfileIdentity(),
      binding:
      BindingsBuilder(() => {

      }),
    ),

    GetPage(
      name: profilePrivacyAlertPage,
      page: () => ProfilePrivacyAlert(),
      binding:
      BindingsBuilder(() => {

      }),
      transitionDuration: Duration(milliseconds: 0),

    ),
  ];
}


class SizeTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (!(Get.routing.current == RouteConfig.manualInputPage)) {
      return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(0.0, 0.5),
            ),
          ),
          child: child);
    }
    return Stack(
      children: [
        ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(0, 0.65, curve: Curves.easeOut),
            ),
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color(0xeeffffff),
          ),
        ),
        FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(0, 0.65),
            ),
          ),
          child: child,
          // child: ScaleTransition(
          //   scale: Tween<double>(
          //     begin: 0.5,
          //     end: 1,
          //   ).animate(
          //     CurvedAnimation(
          //       parent: animation,
          //       curve: Interval(0.5, 1.0, curve: CusBounceInOutCurve()),
          //     ),
          //   ),
          //   child: child,
          // ),
        ),
      ],
    );
  }
}

class CusBounceInOutCurve extends Curve {
  const CusBounceInOutCurve._();
  factory CusBounceInOutCurve() {
    return CusBounceInOutCurve._();
  }
  @override
  double transformInternal(double t) {
    //TODO 待优化 改成二次函数会更丝滑
    var x0 = 0.4, x1 = 0.7, x2 = 0.9, up0 = 1.12, up1 = 1.05, down0 = 0.95;
    var ret = 0.0;
    //函数
    if (t < x0)
      ret = up0 / x0 * t;
    // ret =  -10 * t*t + 7*t;
    else if (t < x1)
      ret = up0 + (down0 - up0) / (x1 - x0) * (t - x0);
    // ret =  -3.11 * t*t + 2.42*t + 0.72;
    else if (t < x2)
      ret = down0 + (up1 - down0) / (x2 - x1) * (t - x1);
    // ret =  4.5 * t*t - 6.45*t + 3.21;
    else if (t < 1) ret = up1 - (up1 - 1) / (1 - x2) * (t - x2);
    // ret =  -4 * t*t + 7.1*t - 2.1;

    // logger.d("ret is " + ret.toString());
    return ret;
  }
// double _bounce(double t) {
//   if (t < 1.0 / 2.75) {
//     return 7.5625 * t * t;
//   } else if (t < 2 / 2.75) {
//     t -= 1.5 / 2.75;
//     return 7.5625 * t * t + 0.75;
//   } else if (t < 2.5 / 2.75) {
//     t -= 2.25 / 2.75;
//     return 7.5625 * t * t + 0.9375;
//   }
//   t -= 2.625 / 2.75;
//   return 7.5625 * t * t + 0.984375;
// }
}
