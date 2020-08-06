import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cabinett/locator.dart';
import 'package:flutter_cabinett/model/Order.dart';
import 'package:flutter_cabinett/services/db_manager.dart';
import 'package:flutter_cabinett/views/orders/order_page.dart';

class PayMain extends StatefulWidget {
  PayMain({Key key}) : super(key: key);
  final dbManager = locator<DBManager>();

  @override
  _PayMainState createState() => _PayMainState();
}

class _PayMainState extends State<PayMain>
    with AutomaticKeepAliveClientMixin<PayMain> {
  final dbManager = locator<DBManager>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int amountSelected = 0;

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              child: Container(
                margin: EdgeInsets.only(left: 19, right: 18, top: 23),
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [Color(0xFFD791A6), Color(0xFFFFA67B)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
              ),
              top: 0,
              left: 0,
              right: 0,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Text(
                      "Số dư ví",
                      style: TextStyle(fontSize: 19, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 21),
                    child: FutureBuilder<DataSnapshot>(
                      future: dbManager.refUser.child('amount').once(),
                      builder: (ctx, snapshot) {
                        return Text(
                          snapshot.data?.value?.toString() ?? '0',
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 150),
                      child: Text(
                        "Mua điểm",
                        style:
                        TextStyle(fontSize: 17, color: Color(0xff8E9DA4)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 19, top: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: SizedBox(
                            width: 100,
                            height: 40,
                            //nút người dùng nhấn 50000.
                            child: RaisedButton(
                              onPressed: () async {
                                setState(() {
                                  amountSelected =
                                  amountSelected == 50000 ? 0 : 50000;
                                });
                                print(amountSelected);
                              },
                              child: Text(
                                "50.000",
                                style: TextStyle(
                                    color: Color(0xff8E9DA4), fontSize: 15),
                              ),
                              color: amountSelected == 50000
                                  ? Color(0xffEE9E8E)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 19,
                        ),
                        Container(
                          child: SizedBox(
                            width: 100,
                            height: 40,
                            child: RaisedButton(
                              onPressed: () async {
                                setState(() {
                                  amountSelected =
                                  amountSelected == 100000 ? 0 : 100000;
                                });
                              },
                              child: Text(
                                "100.000",
                                style: TextStyle(
                                    color: Color(0xff8E9DA4), fontSize: 15),
                              ),
                              color: amountSelected == 100000
                                  ? Color(0xffEE9E8E)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 19,
                        ),
                        Container(
                          child: SizedBox(
                            width: 100,
                            height: 45,
                            child: RaisedButton(
                              onPressed: () async {
                                setState(() {
                                  amountSelected =
                                  amountSelected == 150000 ? 0 : 150000;
                                });
                              },
                              child: Text(
                                "150.000",
                                style: TextStyle(
                                    color: Color(0xff8E9DA4), fontSize: 15),
                              ),
                              color: amountSelected == 150000
                                  ? Color(0xffEE9E8E)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 19, top: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: SizedBox(
                            width: 100,
                            height: 40,
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  amountSelected =
                                  amountSelected == 200000 ? 0 : 200000;
                                });
                              },
                              child: Text(
                                "200.000",
                                style: TextStyle(
                                    color: Color(0xff8E9DA4), fontSize: 15),
                              ),
                              color: amountSelected == 200000
                                  ? Color(0xffEE9E8E)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 19,
                        ),
                        Container(
                          child: SizedBox(
                            width: 100,
                            height: 40,
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  amountSelected =
                                  amountSelected == 500000 ? 0 : 500000;
                                });
                              },
                              child: Text(
                                "500.000",
                                style: TextStyle(
                                    color: Color(0xff8E9DA4), fontSize: 15),
                              ),
                              color: amountSelected == 500000
                                  ? Color(0xffEE9E8E)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 19,
                        ),
                        Container(
                          child: SizedBox(
                            width: 105,
                            height: 45,
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  amountSelected =
                                  amountSelected == 1000000 ? 0 : 1000000;
                                });
                              },
                              child: Text(
                                "1.000.000",
                                style: TextStyle(
                                    color: Color(0xff8E9DA4), fontSize: 15),
                              ),
                              color: amountSelected == 1000000
                                  ? Color(0xffEE9E8E)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
//                  Center(
//                    child: Padding(padding:EdgeInsets.only(top: 20),
//                      child: Text("100000000VND",style: TextStyle(color: Colors.lightBlueAccent,fontSize: 20),),
//                    ),
//                  ),
                  Container(
                      padding: EdgeInsets.only(top: 30),
                      child: RaisedButton(
                        onPressed: () async {
                          if (amountSelected == 0) {
                            return;
                          }

                          final timestamps =
                              new DateTime.now().millisecondsSinceEpoch;

                          final value = amountSelected;

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderPage(
                                    data: Orders(
                                        timestamp: timestamps,
                                        reason: 'Nạp Tiền',
                                        money: value),
                                  )));

                          setState(() {
                            amountSelected = 0;
                          });
                        },
                        color: Color(0xFFCC8257),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        child: SizedBox(
                          width: 220,
                          height: 40,
                          child: Center(
                            child: Text("Mua điểm",
                                style: TextStyle(
                                    fontSize: 17.0, color: Colors.white)),
                          ),
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
