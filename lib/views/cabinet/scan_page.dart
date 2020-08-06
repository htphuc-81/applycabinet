import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_cabinett/main.dart';
import 'package:flutter_cabinett/model/Locks.dart';
import 'package:flutter_cabinett/services/db_manager.dart';
import 'package:flutter_cabinett/views/cabinet/cabinet_page.dart';
import 'package:flutter_cabinett/model/Locks.dart';
import 'package:flutter_cabinett/model/StatusLock.dart';
import 'package:flutter_cabinett/views/cabinet/hirecabinet_page.dart';
import 'package:flutter_cabinett/views/dialog/msg_dialog.dart';
import 'package:flutter_cabinett/views/widgets/custom_dialog.dart';
import 'package:intl/intl.dart';
import '../../locator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ScanPage extends StatefulWidget {
  ScanPage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ScanPage>
    with AutomaticKeepAliveClientMixin<ScanPage> {
  final dbManager = locator<DBManager>();
  String result = "";
  Locks _lock;

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      print(qrResult);
      final snapshot = await dbManager.refLock.once();
      final listLocks = snapshot.value as Map;

      if (listLocks.containsKey(qrResult)) {
        Map dataChild = listLocks[qrResult];
        final lockData = Locks.from(data: dataChild, key: qrResult);
        print(lockData);
        final mathuetu =
            await dbManager.refUser.child('hiretimes').child('matuthue').once();

        if (lockData.Status.Hired == false) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HireCabinetPage(
                        data: lockData,
                        db: dbManager.refLock.child(qrResult),
                        code: qrResult,
                      ))).then((_) {
            _checkLockHired(qrResult);
          });
          ;
          return;
        }

        if (lockData.Status.Hired == true && mathuetu.value == qrResult) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CabinetPage(
                        data: lockData,
                        db: dbManager.refLock.child(qrResult),
                      ))).then((_) {
            _checkLockHired(qrResult);
          });

          return;
        }

        if (lockData.Status.Hired == true && mathuetu.value == null) {
          Alert(
              context: context,
              //type: AlertType.success,
              title: "Thông báo",
              desc: "Tủ đã thuê quý khách vui lòng thuê tủ khác",
              image: Image.asset("assets/images/icon_success.png"),
              buttons: [
                DialogButton(
                  child: Text(
                    "về trang chủ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.of(context).pushNamed('/home'),
                  width: 140,
                )
              ],
              closeFunction: () {
                Navigator.pop(context);
              }).show();
        }
      }
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      result = "Unknown Error $ex";
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black26,
    ));
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: _lock == null ? _scanQr : _hiredLock,
      ),
    );
  }

  Widget get _scanQr => Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            Text(
              "Đưa camera vào vị trí mã QR Code để mở tủ",
              style: TextStyle(color: Color(0xFF6E8089)),
            ),
            Image.asset("assets/images/qrcode.png"),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: Image.asset("assets/images/Vector.png"),
                onPressed: _scanQR,
              ),
            )
          ],
        ),
      );

  Widget get _hiredLock => Container(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(),
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: true,
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
                          "Đang thuê tủ ",
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
                                // đúng
                                'assets/images/Artboard.png',
                              ),
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
                          _checkLockHiredUser();
                        },
                        color: Color(0xFFCC8257),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        child: SizedBox(
                          width: 240,
                          height: 40,
                          child: Center(
                            child: Text("Hủy thuê",
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
                         // Navigator.of(context).pushNamed('/home');
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (BuildContext context) => HomeController()));
                        },
                        color: Color(0xFFCC8257),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        child: SizedBox(
                          width: 240,
                          height: 40,
                          child: Center(
                            child: Text("Về trang chủ",
                                style: TextStyle(
                                    fontSize: 17.0, color: Colors.white)),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                ].where((widget) => widget != null).toList(),
              ),
            ),
          ),
        ),
      );

  Future _checkLockHired(String lockKey) async {
    final lockDataCurrent = await dbManager.refLock.child(lockKey).once();
    final lockData = lockDataCurrent.value as Map;
    //print(lockData['Status']);
    // gán lock đang thuê ở đây
    //final  mlock = Locks.from(data: lockData, key: 'lock_1' );
    //final mHired = mlock.Status.Hired;
    final lock = Locks.from(key: lockKey, data: lockData);
    if (lock.Status.Hired) {
      setState(() {
        _lock = lock;
      });
    } else {
      _lock = null;
    }
  }

  Future _checkLockHiredUser() async {
    final lockUser =
        await dbManager.refUser.child('hiretimes').child('matuthue').once();
    final lockUserData = lockUser.value;
    print(lockUserData);
    if (lockUserData == null) {
      setState(() {
        _lock = null;
      });
    } else {
      await _checkLockHired(lockUserData);
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
                 _showVerifyEmailSentDialog(money,usedHired);
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
          closeFunction: () {
            Navigator.pop(context);
          }).show();
    }
  }

  String getOrderId(int timestamps) {
    return 'order_$timestamps';
  }

  Future _updateHired() async {
    final lockdata =
        await dbManager.refUser.child('hiretimes').child('matuthue').once();
    final lockHired = lockdata.value;
    print(lockHired);
    await dbManager.refLock
        .child(lockHired)
        .child('Status')
        .child('Hired')
        .set(false);
  }

  Future _updateOrder(int money) async {
    final timestamps = new DateTime.now().millisecondsSinceEpoch;
    final getorderid = getOrderId(timestamps);
    await dbManager.refHistory.child(getorderid).once();
    await dbManager.refHistory.child(getorderid).update({
      'money': money,
      'reason': 'Thuê tủ',
      'timestamp': timestamps,
    });
    await _updateHired();
    final matuthueRemove = await dbManager.refUser.child('hiretimes').child('matuthue').remove();
  }

  Future<int> _hireTimes() async {
    final endTimes = new DateTime.now().millisecondsSinceEpoch;
    final starTimesData =
        await dbManager.refUser.child('hiretimes').child('startimes').once();
    final int starTimes = starTimesData.value;

    return (endTimes - starTimes);
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
                //Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

  //  _checkLockHiredUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
