import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unipus_iwrite/models/auth.dart';
import 'package:unipus_iwrite/route/route_config.dart';
import 'package:unipus_iwrite/scenes/login_page.dart';
import 'package:unipus_iwrite/utils/event_bus.dart';
import 'package:unipus_iwrite/utils/sp_utils.dart';

// class UserInfo {
//   String? name;
//   String? email;
//   String userId;
//   String mobile;
//
//   UserInfo({this.name,this.email,required this.userId, required this.mobile});
//   factory UserInfo.fromJson(Map<String, dynamic> json) {
//     return UserInfo(
//         name: json['name']?? "" ,
//         email :json['email']?? "",
//         userId:json['userId'] as String,
//         mobile :json['mobile'] as String,
//
//     );
//   }
//   Map<String, dynamic> UserInfoToJson(UserInfo instance) =>
//       <String, dynamic>{
//         'name': instance.name,
//         'email': instance.email,
//         'userId': instance.userId,
//         'mobile': instance.mobile,
//       };
//
// }

class UserManager {
  // late String? token;
  Auth? auth;

  setAuth(Auth auth) {
    this.auth = auth;
    SpUtil.getInstance().set(SpUtil.KEY_LOGIN_AUTH, jsonEncode(auth.toJson()));
  }

  getAuth() {
    return auth;
  }

  // UserManager ，需要在SpUtil.init后再初始化
  factory UserManager() => _instance;

  static late final UserManager _instance = UserManager._internal();

  UserManager._internal() {
    String authStr = SpUtil.getInstance().getString("login_auth");
    // 都从缓存中读取，没有的话，请求后存储
    if (authStr != "") {
      this.auth = Auth.fromJson(jsonDecode(authStr));
    }
  }

  bool isLogin() {
    return (this.auth != null && (this.auth!.accessToken ?? "").length > 1);
  }

  void logout() {
    _instance.auth = null;
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.remove("login_token");
      prefs.remove("login_auth");
      prefs.remove(SpUtil.kSPTouristUid);
      bus.sendBroadcast("logoutSuccess");
    });
  }

  void login(context){
    showDialog(context: context,
        useSafeArea:false,
        barrierColor: Colors.transparent,
        builder: (ctx){
          return LoginPage();
        });
  }
}
