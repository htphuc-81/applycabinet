import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cabinett/model/StatusLock.dart';
class Locks {
  String defineKey;
  StatusLock Status;
  String Name;
  //String mName;
  Locks.from({String key, Map data}) {
    defineKey = key;
    Status = StatusLock.fromSnapshot(data['Status']);
    Name = data['name'];
  }
  //constuctor
  Locks(this.Status,this.defineKey,this.Name);
}
