
import 'package:flutter/material.dart';
import 'package:unipus_iwrite/utils/event_bus.dart';

///导航栈的变化监听
class MyNavigator extends NavigatorObserver{

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    String? previousName = '';
    String? currentName = '';
    if (route.settings == null || route.settings.name == null){
      currentName = "";
    }else {
      currentName = route.settings.name!;
    }
    if (previousRoute == null || previousRoute.settings == null || previousRoute.settings.name == null){
      previousName = '';
    }else {
      previousName = previousRoute.settings.name!;
    }
    bus.sendBroadcast("didPop_route", [currentName, previousName]);

    try{
      print('YM----->NavObserverDidPop--Current:' + currentName + '  Previous:' + previousName);

    } catch (e){
      print(e.toString());
    }

  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    bus.sendBroadcast("didPush_route", route);
    String? previousName = '';
    String? currentName = '';
    if (route.settings == null || route.settings.name == null){
      currentName = "";
    }else {
      currentName = route.settings.name!;
    }
    if (previousRoute == null || previousRoute.settings == null || previousRoute.settings.name == null){
      previousName = '';
    }else {
      previousName = previousRoute.settings.name!;
    }
    try{
      print('YM-------NavObserverDidPush-Current:' + currentName + '  Previous:' + previousName);
    }catch (e){
      print(e.toString());
    }

  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute,oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
  }
}
