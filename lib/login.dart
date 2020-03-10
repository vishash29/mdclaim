import 'package:flutter/material.dart';
import 'appHomePage.dart';
import 'model/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'common/widgets.dart';
import 'services/userService.dart';
import 'package:flutter/gestures.dart';

class MyClaimsLoginPage extends StatefulWidget {
  MyClaimsLoginPage({Key key, this.tabController, this.title})
      : super(key: key);

  final String title;
  TabController tabController;

  @override
  _MyClaimsHomePageState createState() => _MyClaimsHomePageState();
}

class _MyClaimsHomePageState extends State<MyClaimsLoginPage>
    with AutomaticKeepAliveClientMixin<MyClaimsLoginPage> {
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  TabController _tabController;
  User user = User();
  bool disabled=false;

  @override
  bool get wantKeepAlive => true;

  void initState() {
    super.initState();

    /* _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );*/
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    // print('will display $message USING state ${_scaffoldKey.currentState} key $_scaffoldKey');
    /*_scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
    */
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(message),
    ));
  }



  void loginClick() async {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print('calling mondLogin');
     var serviceReturModel= await loginToMondCloud(user.email, user.password);
     print('got back login ${serviceReturModel}');
        if (serviceReturModel != null) {
          if (!serviceReturModel.isSuccess){
            showMessage(serviceReturModel.message);
            return;
          }
          user=serviceReturModel.dynamicData;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ClaimsHomePage(user: user)),
          );
        }
      }

  }

  void _emailAddressChanged(String text) {
    user.email = text.trim().toLowerCase();
  }

  String _validateEmailAddress(String val) {
    return val.isEmpty ? 'Please enter your email to login' : null;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            top: false,
            bottom: false,
            child: Form(
              key: _formKey,
              autovalidate: false,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  textFieldWithIcon(
                    disabled: disabled,
                      labelText: 'Email Address',
                      labelStyle: style14,
                      onChanged: _emailAddressChanged,
                      validator: _validateEmailAddress,
                      imageLink: 'assets/images/email.png'),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    style: style14,
                    onChanged: (text) {
                      user.password = text.trim();
                    },
                    validator: (val) => val.isEmpty
                        ? 'Please enter your password to login'
                        : null,
                    decoration: InputDecoration(
                        prefixIcon: const ImageIcon(
                          AssetImage('assets/images/password.png'),
                          color: Color(0xff011977),
                        ),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: width * 0.05,
                        ),
                        roundedGradientButton(
                            disabled: disabled,
                            text: 'Log In', onPressed: loginClick),
                        SizedBox(
                          width: width * 0.01,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'By Logging In,',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          children: <TextSpan>[
                        TextSpan(
                            text: ' you accept the mondClaims',
                            style: TextStyle(color: Colors.black, fontSize: 15)),
                        TextSpan(
                            text: ' User Agreement',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('what to do here?');
                              })
                      ])),
                  SizedBox(
                    height: 15.0,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'Forgot',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          children: <TextSpan>[
                        TextSpan(
                            text: ' password?',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                //registerClick();
                              })
                      ])),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _signInGoogleButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        /*  UserService service = UserService();
        service.signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ClaimsHomePage(user:User());
              },
            ),
          );
        });*/
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/images/google_logo.png"),
                height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
