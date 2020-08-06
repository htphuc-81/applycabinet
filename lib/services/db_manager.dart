import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_cabinett/locator.dart';
import 'package:flutter_cabinett/services/user_manager.dart';
import 'package:intl/intl.dart';
import 'dart:math' show Random;
class DBManager {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference refUsers;
  DatabaseReference feedBacks;
  DatabaseReference refHistorys;
  DatabaseReference refLocks;
  final userManger = locator<UserManager>();

  DBManager() {
    refUsers = _database.reference().child('users');
    feedBacks = _database.reference().child('feedbacks');
    refHistorys = _database.reference().child('orders');
    refLocks = _database.reference().child('iot-data/gateway 451355643212455/locks');

  }

  DatabaseReference get refUser {
    if (!userManger.isLogin) return null;

    return refUsers.child(userManger.uid);
  }
  DatabaseReference get refHistory{

    return refUsers.child(userManger.uid).child('order');
  }
  DatabaseReference get feedBack{
    return feedBacks;
  }
  DatabaseReference get refLock{
    return refLocks;
  }
}
