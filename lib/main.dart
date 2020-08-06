import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cabinett/locator.dart';
import 'package:flutter_cabinett/services/share_prefs.dart';
import 'package:flutter_cabinett/services/user_manager.dart';
import 'package:flutter_cabinett/views/cabinet/hirecabinet_page.dart';
import 'package:flutter_cabinett/views/feedback_page.dart';
import 'package:flutter_cabinett/views/help_page.dart';
import 'package:flutter_cabinett/views/information_page.dart';
import 'package:flutter_cabinett/views/login/signin_signup_view.dart';
import 'package:flutter_cabinett/views/cabinet/scan_page.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter_cabinett/views/cabinet/cabinet_page.dart';
import 'package:flutter_cabinett/views/main_page.dart';
import 'package:flutter_cabinett/views/orders/order_page.dart';
import 'package:flutter_cabinett/views/seemore_page.dart';
import 'package:flutter_cabinett/views/splash_page.dart';

//import 'package:flutter_cabinett/views/widgets/provider_widget.dart';
import 'package:flutter_cabinett/views/widgets/custom_dialog.dart';
import 'package:flutter_cabinett/services/auth_service.dart';

//import 'package:flutter_cabinett/views/login/sign_up_view.dart';
import 'package:flutter_cabinett/views/first_page.dart';
import 'package:flutter_cabinett/views/main_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cabinett/views/payment/pay_page.dart';
import 'package:flutter_cabinett/views/profile_page.dart';
import 'package:flutter_cabinett/views/orders/history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  final prefs = locator<SharePrefs>();
  prefs.prefs = await SharedPreferences.getInstance();

  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: const FirebaseOptions(
      googleAppID: '1:926106103675:android:0cae95dc257a2068',
      apiKey: 'AIzaSyCVb7p4FYe-E3Rmb8U4hc-E7laKLMZy_RY',
      databaseURL: 'https://cabinet-lock.firebaseio.com',
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final userManager = locator<UserManager>();

  get context => null;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (context) => AuthService(),
        )
      ],
      child: MaterialApp(
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/signUp': (BuildContext context) =>
              SignInSignUpView(authFormType: AuthFormType.signUp),
          '/signIn': (BuildContext context) =>
              SignInSignUpView(authFormType: AuthFormType.signIn),
          '/home': (BuildContext context) => HomeController(),
          '/payment': (BuildContext context) => PayMain(),
          '/profile': (context) => ProfilePage(),
          '/seemore': (BuildContext context) => SeemorePage(),
          '/mainpage': (context) => MainPage(),
          '/historypage': (context) => HistoryPage(),
          '/informationpage': (context) => InformationPage(),
//          '/orderpage': (context) => OrderPage(),
          '/feedback': (context) => FeedBackPage(),
          '/help': (context) => HelpPage(),
          '/hired': (context) => HireCabinetPage(),
          '/first': (context) => FirstView(),
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final AuthService auth = Provider.of(context).auth;
    final auth = Provider.of<AuthService>(context, listen: false);
    return StreamProvider<String>(
      create: (_) => auth.onAuthStateChanged,
      child: Consumer<String>(builder: (BuildContext context, value, Widget child) {
        if (value == null) {
          return SplashScreen();
        }
        return MainPage();
      }),
    );
  }
}