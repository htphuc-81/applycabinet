import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cabinett/model/Order.dart';
import 'package:flutter_cabinett/model/Order.dart';
import 'package:flutter_cabinett/services/db_manager.dart';
import 'dart:math';

import 'package:intl/intl.dart';

import '../../locator.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key}) : super(key: key);
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with AutomaticKeepAliveClientMixin<HistoryPage> {
  List<Orders> itemsOrders = List();
  DatabaseReference itemRefOrders;
  final dbManager = locator<DBManager>();
  final f = new DateFormat('yyyy-MM-dd hh:mm');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemRefOrders = dbManager.refHistory;
    itemRefOrders.onChildAdded.listen(_onEntryAddedOrders);
    itemRefOrders.onChildChanged.listen(_onEntryChangedOrders);
  }

  _onEntryAddedOrders(Event event) {
    setState(() {
      itemsOrders.add(Orders.fromSnapshot(event.snapshot));
      print(Orders.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChangedOrders(Event event) {
    var old = itemsOrders.singleWhere((entry) {
      return entry.defiKey == event.snapshot.key;
    });
    setState(() {
      itemsOrders[itemsOrders.indexOf(old)] =
          Orders.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(top: 40, left: 15),
                child: Text(
                  "Lịch sử giao dịch",
                  style: TextStyle(
                      color: Color(0xff273A44),
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              )),
            ],
          ),
        ),
      ),
      body: Container(
        child: FirebaseAnimatedList(
            query: itemRefOrders,
            itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation,
                int index) {
              return Container(
                child: Column(
                  children: <Widget>[
                    Divider(height: 5.0),
                    ListTile(
                      title: Container(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                  child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      "Mã giao dịch :",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xffACBDC5)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.key,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xffFC9A57)),
                                    ),
                                  )
                                ],
                              )),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(),
                                      child: Text(
                                        "Ngày thanh toán : ",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Color(0xffACBDC5)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        f.format(new DateTime
                                                .fromMillisecondsSinceEpoch(
                                            snapshot.value['timestamp'])),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff273A44)),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                      subtitle: Container(
                          margin: EdgeInsets.only(top: 5, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Lý do : ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xffACBDC5)),
                                    ),
                                    Expanded(
                                        child: Text(
                                      snapshot.value['reason'].toString(),
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xff8E9DA4)),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(),
                                      child: Text(
                                        "Số tiền : ",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Color(0xffACBDC5)),
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      snapshot.value['money'].toString() +
                                          " VNĐ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xff47A945)),
                                    ))
                                  ],
                                ),
                              )
                            ],
                          )),
//                      onTap: (){
////                        Navigator.push(context, MaterialPageRoute(
////                          builder: (context) => DetailPage(
////                          ),
////                        ));
////                      },
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
