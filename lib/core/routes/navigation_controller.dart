import 'package:flutter/material.dart';

class NavigationController {
  final navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> push({required String routeName, Object? args}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: args,
    );
  }

  Future<dynamic> replaceWith({required String routeName, Object? args}) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: args,
    );
  }

  Future<dynamic> removeUntil({required String routeName, Object? args}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: args,
    );
  }

  void pop() => navigatorKey.currentState!.pop();
}
