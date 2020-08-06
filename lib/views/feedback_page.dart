import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cabinett/services/db_manager.dart';
import 'package:flutter_cabinett/views/widgets/custom_appbar.dart';

import '../locator.dart';
import 'dialog/msg_dialog.dart';

class FeedBackPage extends StatefulWidget {
  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _autovalidate = false;
  String title, description;
  final dbManager = locator<DBManager>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Phản hồi ý kiến",
        hasBack: true,
      ),
      body: Container(
          margin: EdgeInsets.only(top: 60),
          child: Form(
            key: _key,
            autovalidate: _autovalidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 17),
                  child: Text(
                    "Title :",
                    style: TextStyle(fontSize: 14, color: Color(0xff838383)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            border: Border.all(width: 1.2, color: Colors.white),
                            borderRadius:
                            BorderRadius.all(const Radius.circular(4.0)),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 8.0),
                            ]),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontSize: 15, color: Color(0xFFAFB7C2)),
                            contentPadding: EdgeInsets.all(15),
                            border: InputBorder.none,
                          ),
                          //maxLength: 20,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          validator: validatorTitle,
                          onSaved: (val) {
                            title = val;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 18, top: 20),
                  child: Text(
                    "Issue description :",
                    style: TextStyle(fontSize: 14, color: Color(0xff838383)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 17, right: 16, top: 10),
                  decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      //borderRadius:
                      //BorderRadius.all(const Radius.circular(4.0)),
                      borderRadius: BorderRadius.all(Radius.zero),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xff1A000000),
                            blurRadius: 15.0,
                            offset: Offset(0, 4)),
                      ]),
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    maxLines: 3,
                    //autofocus: true,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    validator: validatDescription,
                    decoration: InputDecoration(
                      hintStyle:
                      TextStyle(fontSize: 15, color: Color(0xFFAFB7C2)),
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none,
                    ),
                    onSaved: (val) {
                      description = val;
                    },
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 30, left: 40),
                    child: RaisedButton(
                      onPressed: _sendToServer,
                      color: Color(0xFFCC8257),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      child: SizedBox(
                        width: 260,
                        height: 40,
                        child: Center(
                          child: Text("Gửi",
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.white)),
                        ),
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  String validatorTitle(String val) {
    return val.length == 0 ? "Enter title" : null;
  }

  String validatDescription(String val) {
    return val.length == 0 ? "Enter description" : null;
  }

  _sendToServer() {
    final form = _key.currentState;
    if (form.validate()) {
      _key.currentState.save();
      var data = {"title": title, "description": description};
      dbManager.feedBack.push().set(data).then((v) {
        _key.currentState.reset();

        MsgDialog.showMsgDialog(
            context, "Thành công", "Cảm ơn quý khách đã phản hồi");
      });
    } else {
      _autovalidate = true;
    }
  }
}
