import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cabinett/model/Order.dart';
import 'package:flutter_cabinett/views/cabinet/cabinet_page.dart';
import 'package:flutter_cabinett/views/cabinet/scan_page.dart';
import 'package:flutter_cabinett/model/Locks.dart';
import 'package:flutter_cabinett/services/db_manager.dart';
import 'package:flutter_cabinett/views/dialog/msg_dialog.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../locator.dart';

class HireCabinetPage extends StatefulWidget {
  final Locks data;
  final DatabaseReference db;
  final dbManager = locator<DBManager>();
  final Orders orders;
  String code;

  HireCabinetPage(
      {Key key, @required this.data, this.db, this.orders, this.code})
      : super(key: key);

  @override
  _HireCabinetPageState createState() => _HireCabinetPageState();
}

class _HireCabinetPageState extends State<HireCabinetPage> {
  StreamSubscription<Event> _changedSubscription;
  bool isClosed = false;
  var results, amoutResults;
  final dbManager = locator<DBManager>();

  @override
  void initState() {
    super.initState();

    _changedSubscription =
        widget.db.child('Status').onChildChanged.listen(_onEntryChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _changedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(top: 40, left: 17),
                child: Text(
                  "Cabinet",
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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(),
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: Container(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        children: <Widget>[],
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Tủ số ",
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF6E8089)),
                      ),
                      Text(
                        widget.data.Name,
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF6E8089)),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Image.asset('assets/images/Ellipse.png'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Image.asset('assets/images/Artboard.png'),
                          ),
                        ],
                        alignment: Alignment.bottomCenter,
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: true,
                    //true hien false an
                    child: RaisedButton(
                      onPressed: () async {
                        results =
                            (await dbManager.refUser.child("amount").once())
                                .value;
                        if (widget.data.Status.Hired == false) {
                          if (results >= 50000 && isClosed == false) {
                            //cập nhập thời gian lúc đầu
                            _updatetimes();
                            //chuyển trang cabinetpage
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CabinetPage(
                                      data: widget.data,
                                      db: widget.db,
                                    )));
                            await dbManager.refUser
                                .child('hiretimes')
                                .child('matuthue')
                                .once();
                            dbManager.refUser
                                .child('hiretimes')
                                .child('matuthue')
                                .set(widget.code);
                            _updateLock();
                          }else if( results < 50000){
                            Alert(
                                context: context,
                                //type: AlertType.success,
                                title: "Cảnh báo",
                                desc: "Quý khách vui lòng nạp thêm điểm",
                                image: Image.asset(
                                  "assets/images/pay1.png",
                                  width: 100,
                                  height: 100,
                                ),
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Về trang chủ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed('/home'),
                                    width: 140,
                                  )
                                ],
                                closeFunction: () {
                                  Navigator.pop(context);
                                }).show();
                          }

                        }
                      },
                      color: Color(0xFFCC8257),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      child: SizedBox(
                        width: 240,
                        height: 40,
                        child: Center(
                          child: Text(
                              "Thuê tủ",
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.white)),
                        ),
                      ),
                    )),
              ].where((widget) => widget != null).toList(),
            ),
          ),
        ),
      ),
    );
  }

//nếu key : door_is_open trên firebase bị thay đổi nó sẽ thiết lập  == true ;
  void _onEntryChanged(Event event) {

  }

  String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }

  void _updateLock() {
    widget.db.child('Status').child('Hired').set(true);
  }
  void _updatetimes(){
    final startime =
        new DateTime.now().millisecondsSinceEpoch;
    dbManager.refUser.child('hiretimes').child('startimes').once();
    dbManager.refUser.child('hiretimes').child('startimes').set(startime);
  }

  String getReason() {
    var reason = "thuê tủ";
    return reason;
  }

  String dateTime() {
    DateTime now = DateTime.now();
    String formatted = DateFormat('hh:mm dd-MM-yyyy a').format(now);
    return formatted;
  }

  String getOrderId(int timestamps) {
    return 'order_$timestamps';
  }
}
