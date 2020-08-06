import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class StatusLock {
  bool Hired;
  bool door_is_open;
//constructor
  StatusLock(this.Hired, this.door_is_open);
  //lay key,value snapshot  dang map entry
  StatusLock.fromSnapshot(Map snapshot)
      : Hired = snapshot["Hired"],
        door_is_open = snapshot["door_is_open"];
}
