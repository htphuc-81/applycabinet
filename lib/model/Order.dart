import 'package:firebase_database/firebase_database.dart';

class Orders {
  String defiKey;
  int timestamp;
  String reason;
  int money;

  String get getIdOrder => 'order_$timestamp';

  Orders({this.defiKey, this.money, this.reason, this.timestamp});

  Orders.from({String key, Map snapshot}) {
    defiKey = key;
    money = snapshot['money'];
    reason = snapshot['reason'];
    timestamp = snapshot['timestamp'];
  }

  Orders.fromSnapshot(DataSnapshot snapshot)
      : defiKey = snapshot.key,
        money = snapshot.value["money"],
        reason = snapshot.value["reason"],
        timestamp = snapshot.value["timestamp"];

  toJson() {
    return {
      "money": money,
      "reason": reason,
      "timestamp": timestamp,
    };
  }
}
