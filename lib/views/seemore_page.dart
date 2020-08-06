import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_cabinett/views/widgets/provider_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_cabinett/services/db_manager.dart';
import 'package:flutter_cabinett/locator.dart';
import 'dart:async';
import 'package:flutter_cabinett/services/auth_service.dart';
import 'package:provider/provider.dart';

class SeemorePage extends StatefulWidget {
  SeemorePage({Key key}) : super(key: key);

  @override
  _SeemorePageState createState() => _SeemorePageState();
}

class _SeemorePageState extends State<SeemorePage>
    with AutomaticKeepAliveClientMixin<SeemorePage> {
  final dbManager = locator<DBManager>();
  int page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 30, top: 24),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 30, left: 5),
                    child: InkWell(
                        child: Icon(
                      Icons.person,
                      size: 30,
                    )),
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: InkWell(
                          child: FutureBuilder<DataSnapshot>(
                            future: dbManager.refUser.child('username').once(),
                            builder: (ctx, snapshot) {
                              return Text(
                                  snapshot.data?.value?.toString() ?? '',
                                  style: TextStyle(
                                      fontSize: 25, color: Color(0xFF6F7E85)));
                            },
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('/profile');
                          },
                        )),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Image.asset("assets/images/line1.png"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 42, top: 29),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Image.asset("assets/images/Group.png"),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(),
                      child: InkWell(
                        child: Text(
                          "Trợ giúp/Hướng dẫn",
                          style:
                              TextStyle(fontSize: 19, color: Color(0xFF6F7E85)),
                        ),
                        onTap: () async {
                          await Navigator.of(context).pushNamed('/help');
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 42, top: 32),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: SvgPicture.asset('assets/images/Like.svg'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(),
                      child: InkWell(
                        child: Text(
                          "Phản hồi ý kiến",
                          style:
                              TextStyle(fontSize: 19, color: Color(0xFF6F7E85)),
                        ),
                        onTap: () async {
                          var data = await Navigator.of(context)
                              .pushNamed('/feedback');
                          print(data);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 42, top: 36),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Image.asset("assets/images/infor.png"),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(),
                      child: InkWell(
                        child: Text(
                          "Thông tin ứng dụng",
                          style:
                              TextStyle(fontSize: 19, color: Color(0xFF6F7E85)),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed('/informationpage');
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 42, top: 36),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Image.asset(
                      "assets/images/log.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(),
                        child: InkWell(
                          onTap: () async {
                            try {
//                              AuthService auth = Provider.of(context).auth;
                              final auth = Provider.of<AuthService>(context,
                                  listen: false);
                              dbManager.userManger.remove();
                              await auth.signOut();
                              print("Signed Out!");
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text(
                            "Đăng xuất",
                            style: TextStyle(
                                fontSize: 19, color: Color(0xFF6F7E85)),
                          ),
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
