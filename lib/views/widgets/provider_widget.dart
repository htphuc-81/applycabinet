import 'package:flutter/foundation.dart';
import 'package:flutter_cabinett/services/auth_service.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  // tao authservice de then dang ki dang nhap co the su dung ma new mot lan thi dung inheritedwidget
  final AuthService auth;

  Provider({Key key, Widget child, this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Provider) as Provider);
}