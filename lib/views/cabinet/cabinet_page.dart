import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cabinett/main.dart';
import 'package:flutter_cabinett/model/Order.dart';
import 'package:flutter_cabinett/views/cabinet/hirecabinet_page.dart';
import 'package:flutter_cabinett/views/cabinet/scan_page.dart';
import 'package:flutter_cabinett/model/Locks.dart';
import 'package:flutter_cabinett/services/db_manager.dart';
import 'package:flutter_cabinett/views/dialog/msg_dialog.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../locator.dart';
import 'package:flutter_cabinett/views/login/signin_signup_view.dart';
import 'package:flutter_cabinett/services/db_manager.dart';
import 'package:flutter_cabinett/views/main_page.dart';
class CabinetPage extends StatefulWidget {
  final Locks data;
  final DatabaseReference db;
  final dbManager = locator<DBManager>();
  final Orders orders;
  CabinetPage({Key key, @required this.data, this.db, this.orders})
      : super(key: key);

  @override
  _CabinetPageState createState() => _CabinetPageState();
}

class _CabinetPageState extends State<CabinetPage> {
  StreamSubscription<Event> _changedSubscription;
  bool isClosed = false, isAmount = false;
  final dbManager = locator<DBManager>();
  var amoutResults;
  var results, times;
  int mEndMinutes, mStartMinutes, a, b;
  final f = new DateFormat('hh:mm');
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
      resizeToAvoidBottomPadding: true,
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
                  visible: widget.data.Status.door_is_open,
                  child: Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        children: <Widget>[],
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(),
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
                            child: Image.asset(
                              widget.data.Status.door_is_open
                                  ? 'assets/images/Artboard1.png' // đúng
                                  : 'assets/images/Artboard.png',
                            ),
                          ),
                        ],
                        alignment: Alignment.bottomCenter,
                      ),
                    ],
                  ),
                ),
                widget.data.Status.door_is_open
                    ? Text(
                        isClosed
                            ? 'Đã đóng Cabin!'
                            : 'Đã mở khóa Cabin thành công!',
                        style:
                            TextStyle(color: Color(0xFFF1785F), fontSize: 16),
                      )
                    : null,
                Visibility(
                    visible: !widget.data.Status.door_is_open,
                    //true hien false an
                    child: RaisedButton(
                      onPressed: () async {
                        if (isClosed) {
                          // == true
                          Navigator.of(context).pushReplacementNamed('/home');
                        } else {
                          _updateLock();
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
                              isClosed ? "Về trang chủ" : "Mở khóa ngay",
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.white)),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 15,
                ),
                Visibility(
                    visible: true,
                    //true hien false an
                    child: RaisedButton(
                      onPressed: () async {
                        if (widget.data.Status.door_is_open == true) {
                          MsgDialog.showMsgDialog(context, "Nhắc nhở",
                              'Quý khách vui lòng đóng tủ trước khi muốn hủy.');
                        } else {
                          await _checkLockHiredUser();
                        }
                      },
                      color: Color(0xFFCC8257),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      child: SizedBox(
                        width: 240,
                        height: 40,
                        child: Center(
                          child: Text("Hủy thuê tủ",
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
    final key = event.snapshot.key;
    if (key != 'door_is_open') {
      return;
    }
    final value = event.snapshot.value;
    setState(() {
      if (!value) {
        isClosed = true;
      }
      widget.data.Status.door_is_open = value;
    });
  }

  void _updateLock() {
    widget.db.child('Status').child('door_is_open').set(true);
  }

  void _updateHired() {
    widget.db.child('Status').child('Hired').set(false);
  }

  Future<int> _hireTimes() async {
    final endTimes = new DateTime.now().millisecondsSinceEpoch;
    final starTimesData =
        await dbManager.refUser.child('hiretimes').child('startimes').once();
    final int starTimes = starTimesData.value;

    return (endTimes - starTimes);
  }
  Future _checkLockHiredUser()async{
     Alert(
      context: context,
      // type: AlertType.warning,
      title: "Nhắc nhở",
      desc: "Quý khách muốn hủy bỏ giao dịch.",
      buttons: [
        DialogButton(
          child: Text(
            "Đồng ý",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            final usedTimes = await _hireTimes();
            final usedHired = (usedTimes/1000).toInt();
            final money = ((usedHired) * 100);
//            Alert(
//                context: context,
//                //type: AlertType.success,
//                title: "Thông báo",
//                desc: "Cảm ơn quý khách đã sử dụng"
//                    "                           "
//                    "Số tiền quý khách khi thuê tủ"
//                    "                              "
//                    "${money} VNĐ",
//                image: Image.asset("assets/images/pay1.png",width: 100,height: 100,),
//                buttons: [
//                  DialogButton(
//                    child: Text(
//                      "về trang chủ",
//                      style: TextStyle(color: Colors.white, fontSize: 20),
//                    ),
//                    onPressed: () async{
//                      await Navigator.of(context)
//                          .pushNamed('/home');
//                    },
//                    width: 140,
//                  )
//                ],
//                closeFunction: () {
//                  Navigator.pop(context);
//                }).show();
           await _showVerifyEmailSentDialog(money,usedHired);
            final results =
                (await dbManager.refUser.child("amount").once()).value;
            final amountResults = results - money;
            print(amountResults);
            await dbManager.refUser.child('amount').set(amountResults);
            await _updateOrder(money);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Thoát",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }
  Future _updateOrder(int money) async{
    final timestamps = new DateTime.now().millisecondsSinceEpoch;
    final getorderid = getOrderId(timestamps);
    await dbManager.refHistory.child(getorderid).once();
    await dbManager.refHistory.child(getorderid).update({
      'money': money,
      'reason': 'Thuê tủ',
      'timestamp': timestamps,
    });
    await _updateHired();
    await dbManager.refUser
        .child('hiretimes')
        .child('matuthue')
        .remove();
  }
  String getOrderId(int timestamps) {
    return 'order_$timestamps';
  }
  void _showVerifyEmailSentDialog(int money, int usedHired) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Thông báo",style: TextStyle(color: Colors.red,fontSize: 25),),
          content:
          new Text("Bạn đã mất ${money} VNĐ cho ${usedHired}s thuê tủ",style: TextStyle(color: Colors.black),),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Thoát"),
              onPressed: () {
               Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                //Navigator.of(context).pushNamed('/home');
//                Navigator.pushReplacement(
//                    context, MaterialPageRoute(builder: (BuildContext context) => HomeController()));
               // Navigator.of(context).pushNamed('/home');
               // Navigator.of(context).pushReplacementNamed('/mainpage');
//                Navigator.pushAndRemoveUntil(
//                    context,
//                    MaterialPageRoute(builder: (context) => MainPage()),
//                        (route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}


