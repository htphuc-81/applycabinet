import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFFDBE4FC),
                      Color(0xFFFCFDFF)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(right: 170.0,top: 50),
                child: Column(
                  children: <Widget>[
                    Text("Ứng dụng cho",style: TextStyle(fontSize: 25.0,color: Color(0xFF273A44),fontFamily: "DancingScript",fontStyle: FontStyle.italic)),
                    SizedBox(height: 20.0,),
                    Text("Thuê tủ",style: TextStyle(fontSize:25,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic ),)
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 200,top: 50),
                child: SvgPicture.asset(
                 'assets/images/cabinet2.svg',width: 300,height: 200,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text("CABINET APP",style: TextStyle(color: Color(0xffFF5C00),fontSize: 20,fontStyle: FontStyle.italic),),
              )
            ],
          )
        ],
      ),
    );
  }
  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/first');
  }

}
