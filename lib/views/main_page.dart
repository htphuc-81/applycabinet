import 'package:flutter/material.dart';
import 'package:flutter_cabinett/locator.dart';
import 'package:flutter_cabinett/services/bottom_nav_bloc.dart';
import 'package:flutter_cabinett/services/user_manager.dart';
import 'package:flutter_cabinett/views/payment/pay_page.dart';
import 'package:flutter_cabinett/views/cabinet/scan_page.dart';
import 'package:flutter_cabinett/views/seemore_page.dart';
import 'package:flutter_cabinett/services/auth_service.dart';
import 'package:flutter_cabinett/views/widgets/custom_appbar.dart';

//import 'package:flutter_cabinett/views/widgets/provider_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_cabinett/views/orders/history_page.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  AuthService auth;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final userManager = locator<UserManager>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ButtonNavBloc>(
      create: (_) => ButtonNavBloc(),
      child: Consumer<ButtonNavBloc>(builder: (__, bloc, ___) {
        return WillPopScope(
          onWillPop: () async => showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
              title: Text('Warning'),
              content: Text('Do you really want to exit'),
              actions: [
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () => Navigator.pop(c, true),
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(c, false),
                ),
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(page: bloc.currentIndex),
//            PreferredSize(
//              preferredSize: Size.fromHeight(100),
//              child: Container(
//                padding: EdgeInsets.only(top: 10),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Expanded(
//                        child: Container(
//                          padding: EdgeInsets.only(top: 40, left: 15),
//                          child: Text(
//                            "Cabinet",
//                            style: TextStyle(
//                                color: Color(0xff273A44),
//                                fontSize: 26,
//                                fontWeight: FontWeight.bold),
//                          ),
//                        )),
//                  ],
//                ),
//              ),
//            ),
            body: Stack(
              children: <Widget>[
                Offstage(
                  offstage: bloc.currentIndex != 0,
                  child: ScanPage(
                    key: Key('ScanPage'),
                  ),
                ),
                Offstage(
                  offstage: bloc.currentIndex != 1,
                  child: PayMain(
                    key: Key('PayMain'),
                  ),
                ),
                Offstage(
                  offstage: bloc.currentIndex != 2,
                  child: HistoryPage(
                    key: Key('HistoryPage'),
                  ),
                ),
                Offstage(
                  offstage: bloc.currentIndex != 3,
                  child: SeemorePage(
                    key: Key('SeemorePage'),
                  ),
                )
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: bloc.currentIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/images/cabinet.png"),
                    title: new Text(
                      "Mở tủ",
                      style: TextStyle(
                        fontSize: 15,
                        color: bloc.currentIndex == 0
                            ? Color(0xFFA0522D)
                            : Color(0xFF6F7E85),
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/images/pay.png"),
                    title: new Text(
                      "Thanh toán",
                      style: TextStyle(
                        fontSize: 15,
                        color: bloc.currentIndex == 1
                            ? Color(0xFFA0522D)
                            : Color(0xFF6F7E85),
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/images/order.png",
                      width: 25,
                      height: 30,
                    ),
                    title: new Text(
                      "Đơn hàng",
                      style: TextStyle(
                        fontSize: 15,
                        color: bloc.currentIndex == 2
                            ? Color(0xFFA0522D)
                            : Color(0xFF6F7E85),
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/images/seemore.png"),
                    title: new Text(
                      "Xem thêm",
                      style: TextStyle(
                        fontSize: 15,
                        color: bloc.currentIndex == 3
                            ? Color(0xFFA0522D)
                            : Color(0xFF6F7E85),
                      ),
                    ),
                  ),
                ],
                onTap: (int index) {
                  bloc.currentIndex = index;
                  print(bloc.currentIndex);
                }),
          ),
        );
      }),
    );
  }
}
