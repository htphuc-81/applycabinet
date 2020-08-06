import 'package:flutter_cabinett/locator.dart';
import 'package:flutter_cabinett/services/share_prefs.dart';
import 'dart:math' show Random;
class UserManager {
  final prefs = locator<SharePrefs>();
 // var newID;
  String get uid {
    if (prefs.prefs.containsKey('uid')) {
      return prefs.prefs.get('uid');
    }

    return null;
  }

  bool get isLogin => uid != null;
  //save id user
  void saveUser(String uid) {
    prefs.prefs.setString('uid', uid);
  }

  void remove() {
    prefs.prefs.remove('uid');
  }
  String get newID {
    return prefs.prefs.get('newID');
  }
}
