import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cabinett/model/Users.dart';
import 'package:flutter_cabinett/views/main_page.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_cabinett/services/db_manager.dart';
import 'package:flutter_cabinett/views/widgets/custom_appbar.dart';
import 'package:intl/intl.dart';

import '../locator.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

final notesReference = FirebaseDatabase.instance.reference().child('users');

class _ProfilePageState extends State<ProfilePage> {
  //List<Users>items;
  // StreamSubscription<Event>_onUsersChangedSubscription;
  final dbRef = FirebaseDatabase.instance.reference().child("users");
  final dbManager = locator<DBManager>();
  TextEditingController _firstnameController;
  TextEditingController _lastnameController;
  TextEditingController _usernameController;
  bool enableEditProfile = false;
  FocusNode nodeOne = FocusNode();
  FocusNode nodeTwo = FocusNode();

  @override
  void initState() {
    super.initState();
    _usernameController = new TextEditingController(text: '');
    _firstnameController = new TextEditingController(text: '');
    _lastnameController = new TextEditingController(text: '');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //_onUsersChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Tài khoản cá nhân",
        hasBack: true,
      ),
      body: StreamBuilder(
          stream: dbManager.refUser.onValue,
          builder: (ctx, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasData) {
              DataSnapshot dataValues = snapshot.data.snapshot;
              Map<dynamic, dynamic> values = dataValues.value;
              _firstnameController.text = (values['firstname']).toString();
              _lastnameController.text = (values['lastname']).toString();
              _usernameController.text = (values['username']).toString();
            }
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 30, top: 24),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 0, right: 40),
                            child: Text(
                              "Email:",
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(),
                            child: FutureBuilder<DataSnapshot>(
                                future: dbManager.refUser.child('email').once(),
                                builder: (ctx, snapshot) {
                                  return Text(
                                    snapshot.data?.value?.toString() ?? '',
                                    style: TextStyle(
                                        color: Color(0xff6E8089), fontSize: 15),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 0, right: 10),
                            child: Text(
                              "First name:",
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Container(
                            width: 150,
                            child: TextField(
                              enabled: enableEditProfile,
                              decoration: null,
                              controller: _firstnameController,
                              style: TextStyle(color: Color(0xff6E8089)),
                              autofocus: true,
                              focusNode: nodeOne,
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30, top: 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 0, right: 10),
                            child: Text(
                              "Last name:",
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Container(
                            width: 150,
                            child: TextField(
                              enabled: enableEditProfile,
                              decoration: null,
                              controller: _lastnameController,
                              style: TextStyle(color: Color(0xff6E8089)),
                              autofocus: false,
                              focusNode: nodeTwo,
                              keyboardType: TextInputType.text,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30, top: 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 0, right: 10),
                            child: Text(
                              "User name:",
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Container(
                            width: 150,
                            child: TextField(
                              enabled: enableEditProfile,
                              decoration: InputDecoration.collapsed(hintText: ""),
                              controller: _usernameController,
                              style: TextStyle(color: Color(0xff6E8089)),
                              autofocus: false,
                              autocorrect: false,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 60, left: 50),
                      child: RaisedButton(
                        onPressed: () async {
                          if (enableEditProfile == true) {
                            print(_firstnameController.text);
                            print(_lastnameController.text);
                            print(_usernameController.text);
                            await dbManager.refUser.update({
                              'firstname': _firstnameController.text,
                              'lastname': _lastnameController.text,
                              'username': _usernameController.text,
                            });
                          }
                          setState(() {
                            enableEditProfile = !enableEditProfile;
                          });
                        },
                        color: Color(0xFFCC8257),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        child: SizedBox(
                          width: 250,
                          height: 40,
                          child: Center(
                            child: Text(
                                enableEditProfile ? 'Xong' : 'Cập nhập thông tin',
                                style: TextStyle(
                                    fontSize: 17.0, color: Colors.white)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  void _onUsersUpdated(Event event) {}
}
