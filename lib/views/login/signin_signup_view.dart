import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cabinett/locator.dart';
import 'package:flutter_cabinett/services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_cabinett/services/db_manager.dart';
import 'package:flutter_cabinett/services/user_manager.dart';
import 'package:flutter_cabinett/views/dialog/loading_dialog.dart';
//import 'package:flutter_cabinett/views/widgets/provider_widget.dart';
import 'package:flutter_cabinett/views/dialog/msg_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
// TODO move this to tone location
final primaryColor = Colors.orange;

enum AuthFormType { signIn, signUp, reset }

class SignInSignUpView extends StatefulWidget {
  final AuthFormType authFormType;
  AuthService auth;

  SignInSignUpView({Key key, @required this.authFormType, this.auth})
      : super(key: key);

  @override
  _SignInSignUpViewState createState() =>
      _SignInSignUpViewState(authFormType: this.authFormType);
}

class _SignInSignUpViewState extends State<SignInSignUpView> {
  ProgressDialog pr;
  AuthFormType authFormType;
  final userManager = locator<UserManager>();
  final dbManager = locator<DBManager>();
  bool _isloading;
  FocusNode nodeOne = FocusNode();
  FocusNode nodeTwo = FocusNode();
  _SignInSignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();
  String _email, _password, _lastname, _username, _warning, _firstname;
  AuthFormType _formType = AuthFormType.signIn;
  String _errorMessage;
  bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    setState(() {
      _errorMessage = "";
      _isloading = true;
    });
    if (validateAndSave()) {
      try {
        final auth = Provider.of<AuthService>(context, listen: false);
        String uid = "";
        //var user = FirebaseAuth.instance;
        //LoadingDialog.showLoadingDialog(context, "Loading...");
        if (authFormType == AuthFormType.signIn) {
          uid = await auth.signIn(_email, _password);
          print("Signed In with ID $uid");
          // userManager.saveUser(uid);
          // LoadingDialog.hideLoadingDialog(context);
          if (uid == null) {
            await MsgDialog.showMsgDialog(
                context, "Xác nhận", "Vui lòng xác thực tài khoản");
          } else {
            pr.show();
            Future.delayed(Duration(seconds: 3),(){
              pr.hide();
              Navigator.of(context).pushReplacementNamed('/home');
            });
            userManager.saveUser(uid);
          }
        } else if (authFormType == AuthFormType.reset) {
          await auth.sendPasswordResetEmail(_email);
          print("Password reset email sent");
          _warning = "A password reset link has been sent to $_email";
          setState(() {
            authFormType = AuthFormType.signIn;
          });
        } else {
          uid = await auth.signUp(
              _email, _password, _lastname, _username, _firstname);
          var user = {
            "firstname": _firstname,
            "lastname": _lastname,
            "username": _username,
            "email": _email,
            "id": uid,
            "amount": 0,
          };
          try {
            await _showVerifyEmailSentDialog();
            // await dbManager.refUsers.child(uid).child('amount').set(50000);
            await dbManager.refUsers.child(uid).set(user);
          } catch (e) {
            print("An error occured while trying to send email verification");
            print(e.message);
          }
          print("Signed up with New ID $uid");
        }
        setState(() {
          this._isloading = false;
        });
      } catch (e) {
        print('Err : $e');
        setState(() {
          _isloading = false;
         _warning = e.message;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isloading = false;
  }

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Loading...');
    final _width = MediaQuery
        .of(context)
        .size
        .width;
    final _height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Container(
          color: primaryColor,
          height: _height,
          width: _width,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(height: _height * 0.02),
                showAlert(),
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: SvgPicture.asset(
                    'assets/images/login.svg',width: 100,height: 100,
                  ),
                ),
                //SizedBox(height: _height * 0.01),
                //phan dau
                buildHeaderText(),
                SizedBox(height: _height * 0.01),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: buildInputs() + buildButtons(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signUp) {
      _headerText = "REGISTER";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "Reset Password";
    } else {
      _headerText = "LOGIN";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 35,
        color: Colors.white,
        fontStyle: FontStyle.italic
      ),
    );
  }

// -----------------các ô in input nhập vào-------------------------
  List<Widget> buildInputs() {
    List<Widget> textFields = [];
    if (authFormType == AuthFormType.reset) {
      textFields.add(
        TextFormField(
          focusNode: nodeOne,
          validator: EmailValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration("Enter your email address"),
          onSaved: (value) => _email = value,
        ),
      );
      textFields.add(SizedBox(height: 15));
      return textFields;
    }
    // if were in the sign up state add name
    if (authFormType == AuthFormType.signUp) {
      textFields.add(
        TextFormField(
          focusNode: nodeTwo,
          autocorrect: false,
          validator: FirstNameValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration("First Name"),
          onSaved: (value) => _firstname = value,
        ),
      );
      textFields.add(SizedBox(height: 15));
      textFields.add(
        TextFormField(

          validator: LastNameValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration("Last Name"),
          onSaved: (value) => _lastname = value,
        ),
      );
      textFields.add(SizedBox(height: 15));
      textFields.add(
        TextFormField(
          validator: UserNameValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration("User Name"),
          onSaved: (value) => _username = value,
        ),
      );
      textFields.add(SizedBox(height: 15));
    }
    // add email & password
    textFields.add(
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        validator: EmailValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) => _email = value,
      ),
    );
    textFields.add(SizedBox(height: 15));
    textFields.add(
      TextFormField(
        autocorrect: false,
        validator: PasswordValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Password"),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    );
    textFields.add(SizedBox(height: 10));

    return textFields;
  }

/* --------------------------------------------*/
  /* */
  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding:
      const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }

/*--------------------Cac nút button  và text ---------------------------*/
  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;

    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "Login";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtonText = "Return to Sign in";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
    } else {
      _switchButtonText = "Have an Account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
    }

    return [
      Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.7,
        child: RaisedButton(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.white,
          textColor: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _submitButtonText,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
          ),
          onPressed: submit,
        ),
      ),
      showForgotPassword(_showForgotPassword),
      FlatButton(
        child: Text(
          _switchButtonText,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          switchFormState(_newFormState);
        },
      )
    ];
  }

  /*--------------------------show forgotpassword---------------------------------*/
  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
          new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/signIn');
                //Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
