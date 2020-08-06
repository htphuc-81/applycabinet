import 'package:flutter/material.dart';
import 'package:flutter_cabinett/views/widgets/custom_appbar.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Thông tin ứng dụng",
        hasBack: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/images/Ellipse.png',
                          width: 200,
                          height: 100,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Image.asset(
                          'assets/images/Artboard.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                    alignment: Alignment.bottomCenter,
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Cabinet",
                      style: TextStyle(fontSize: 19, color: Color(0xff273A44)),
                    ),
                  ),
                  Text(
                    "Phiên bản : 2.94_18597_Cabinet",
                    style: TextStyle(fontSize: 15, color: Color(0xff6F7E85)),
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 30),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(),
                          child: Image.asset(
                            'assets/images/store.png',
                            width: 60,
                            height: 30,
                          ),
                        ),
                        Container(
                            child: Text(
                              "Lưu trữ",
                              style:
                              TextStyle(fontSize: 17, color: Color(0xff273A44)),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 40, top: 20),
                    child: Text("41,07 MB"),
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 40, left: 40),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.data_usage,
                            size: 35,
                          ),
                        ),
                        Container(
                            child: Text(
                              "Sử dụng dữ liệu",
                              style:
                              TextStyle(fontSize: 17, color: Color(0xff273A44)),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 40, top: 20),
                    child: Text("569,7 KB"),
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 40, left: 40),
                    child: Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(),
                            child: Icon(
                              Icons.battery_full,
                              size: 35,
                            )),
                        Container(
                            child: Text(
                              "Pin",
                              style:
                              TextStyle(fontSize: 17, color: Color(0xff273A44)),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 40, top: 20),
                    child: Text("0.0 %"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
