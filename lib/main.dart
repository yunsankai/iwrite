import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:unipus_iwrite/base/base_config.dart';
import 'package:unipus_iwrite/route/route_config.dart';
import 'package:unipus_iwrite/route/navigator_observer.dart';
import 'package:unipus_iwrite/scenes/home.dart';
import 'package:unipus_iwrite/scenes/profile_privacy_alert.dart';
import 'package:unipus_iwrite/utils/env_util.dart';
import 'package:unipus_iwrite/utils/sp_utils.dart';


Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    print("捕捉到错误" + details.stack.toString());
    if (!EnvUtil.inProduction) {
      FlutterError.dumpErrorToConsole(details);
    } else {

      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  runZonedGuarded<Future<Null>>(() async {
    runApp(MyApp());
  }, (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key})
      : super(
    key: key,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    var app = GetMaterialApp(
      navigatorObservers: [MyNavigator()],
      title: 'iwrite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        platform: TargetPlatform.iOS
      ),
      // home: HomeScreen(),
      initialRoute: RouteConfig.launchPagePath,
        debugShowCheckedModeBanner:false,
      getPages: RouteConfig.getPages,
    );

    return ScreenUtilInit(
      designSize: Size(375, 812),
      splitScreenMode: false,
      builder: () => app,
    );
  }
}


Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  if (!EnvUtil.inProduction) {
    print(stackTrace);
    return;
  }
  //上报结果处理 //TODO TEST

}
