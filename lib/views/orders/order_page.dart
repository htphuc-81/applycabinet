import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cabinett/locator.dart';
import 'package:flutter_cabinett/model/Order.dart';
import 'package:flutter_cabinett/services/db_manager.dart';
import 'package:flutter_cabinett/views/widgets/custom_appbar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:momo_vn/momo_vn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

class OrderPage extends StatefulWidget {
  final Orders data;
  final dbManager = locator<DBManager>();

  OrderPage({Key key, @required this.data}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  MomoVn _momoPay;
  PaymentResponse _momoPaymentResult;
  String _payment_status;

  @override
  void initState() {
    super.initState();
    _momoPay = MomoVn();
    _momoPay.on(MomoVn.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _momoPay.on(MomoVn.EVENT_PAYMENT_ERROR, _handlePaymentError);
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Xác nhận giao dịch",
        hasBack: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 300,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Center(
                        child: Text(
                          "Thông tin thanh toán",
                          style:
                          TextStyle(fontSize: 18, color: Color(0xff273A44)),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(),
                            child: Text(
                              "Mã đơn hàng :",
                              style: TextStyle(
                                  fontSize: 17, color: Color(0xff797979)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 50),
                              child: Text(
                                widget.data.getIdOrder,
                                style: TextStyle(
                                    fontSize: 17, color: Color(0xffF6B934)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(),
                            child: Text(
                              "Số tiền :",
                              style: TextStyle(
                                  fontSize: 17, color: Color(0xff797979)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 100),
                              child: Text(
                                widget.data.money.toString(),
                                style: TextStyle(
                                    fontSize: 17, color: Color(0xffF6B934)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(),
                            child: Text(
                              "Nội dung :",
                              style: TextStyle(
                                  fontSize: 17, color: Color(0xff797979)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 80),
                              child: Text(
                                widget.data.reason,
                                style: TextStyle(
                                    fontSize: 17, color: Color(0xffF6B934)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(),
                            child: Text(
                              "Tổng tiền :",
                              style: TextStyle(
                                  fontSize: 17, color: Color(0xff797979)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 80),
                              child: Text(
                                widget.data.money.toString(),
                                style: TextStyle(
                                    fontSize: 17, color: Color(0xffF6B934)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 30),
                child: RaisedButton(
                  onPressed: () async {
                    print('amount: ${widget.data.money.toDouble()}');
                    MomoPaymentInfo options = MomoPaymentInfo(
                        merchantname: "Phuchuynh97",
                        merchantcode: 'MOMO5RJ820200324',
                        appScheme: "momo5rj820200324",
                        amount: widget.data.money.toDouble(),
                        orderId: widget.data.getIdOrder,
                        orderLabel: 'Mã đơn hàng',
                        merchantnamelabel: "Nhà cung cấp",
                        fee: 0,
                        description: widget.data.reason,
                        partner: 'MOMO5RJ820200324',
                        username: '202003282110',
                        extra: "",
                        isTestMode: true
                    );
                    try {
                      _momoPay.open(options);
                    } catch (e) {
                      debugPrint(e);
                    }
                  },
                  color: Color(0xFFCC8257),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: SizedBox(
                    width: 220,
                    height: 40,
                    child: Center(
                      child: Text("Thanh toán",
                          style:
                          TextStyle(fontSize: 17.0, color: Colors.white)),
                    ),
                  ),
                )),
            //Text(_payment_status ?? "CHƯA THANH TOÁN"),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _momoPay.clear();
  }

  void _handlePaymentSuccess(PaymentResponse response) {
    setState(() {
      _momoPaymentResult = response;
    });
    if (response.isSuccess) {
      Alert(
          context: context,
          //type: AlertType.success,
          title: "Giao dịch thành công",
          desc: "Bạn đã thanh toán thành công",
          image: Image.asset("assets/images/icon_success.png"),
          buttons: [
            DialogButton(
              child: Text(
                "Về trang chủ",
                style: TextStyle(
                    color: Colors.white, fontSize: 20),
              ),
              onPressed: () =>  Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false),
              width: 140,
            )
          ],
          closeFunction: () {
            Navigator.pop(context);
          }).show();

      widget.dbManager.refHistory
          .child(widget.data.getIdOrder)
          .update(widget.data.toJson());

      widget.dbManager.refUser
          .child('amount')
          .once()
          .then((DataSnapshot value) {
        final int amount = value?.value ?? 0;
        widget.dbManager.refUser
            .child('amount')
            .set(amount + widget.data.money);
      });
    } else {
      Text("Thất bại");
    }
  }

  void _handlePaymentError(PaymentResponse response) {
    setState(() {
      _momoPaymentResult = response;
    });
    if (response.isSuccess == false) {
      Alert(
          context: context,
          //type: AlertType.success,
          title: "Giao dịch thất bại",
          image: Image.asset("assets/images/failed.png"),
          buttons: [
            DialogButton(
              child: Text(
                "Về trang chủ",
                style: TextStyle(
                    color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
              },
              width: 140,
            )
          ],
          closeFunction: () {
            Navigator.pop(context);
          }).show();
    }
  }
}
