import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mdclaim/common/widgets.dart';
import 'model/user.dart';
import 'services/userService.dart';
import 'appHomePage.dart';

class ClaimsRegisterPage extends StatefulWidget {
  final String title;

  ClaimsRegisterPage({Key key, this.title}) : super(key: key);

  @override
  _MyClaimsRegisterPageState createState() => _MyClaimsRegisterPageState();
}

class _MyClaimsRegisterPageState extends State<ClaimsRegisterPage> with AutomaticKeepAliveClientMixin<ClaimsRegisterPage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  bool autoValidate = false;
  User newUser = User();
  bool disabled=false;

  @override
  bool get wantKeepAlive => true;

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input.trim());
  }

  void _submitForm() async {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      print('calling register');
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: new Duration(seconds: 10),
        content: new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text("  Registering...")
          ],
        ),
      ));

      registerUser(newUser).then((returnModel) {
        print(
            'got back from register ${returnModel.message} and success ${returnModel.isSuccess}');
        if (returnModel.isSuccess) {
          showMessage(returnModel.message, Colors.green);
          if (newUser.role == 'I') {
            Route route = MaterialPageRoute(
                builder: (context) => ClaimsHomePage(user: newUser));
            Navigator.pushReplacement(context, route);
          }
          if (newUser.role == 'C') {
            Route route = MaterialPageRoute(
                builder: (context) => ClaimsHomePage(user: newUser));
            Navigator.pushReplacement(context, route);
          }
        } else {
          showMessage(returnModel.message, Colors.red);
        }
      });
    } else {
      showMessage('Please review and correct');
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {

    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: color,content: Text(message),
    ));

  }

  @override
  void initState() {
    super.initState();

    newUser.role = 'C';
  }

  void _onFirstNameChanged(String text){
    newUser.firstName = text;
  }

  String _validateFirstName(String val){
    return val.isEmpty ? 'Please enter your first name' : null;
  }
  void _onLastNameChanged(String text){
    newUser.lastName = text;
  }

  String _validateLastName(String val){
    return val.isEmpty ? 'Please enter your last name' : null;
  }
  void _onPolicyNumberChanged(String text){
    newUser.policyNumber = text;
  }

  String _validatePolicyNumber(String val){
    return val.isEmpty ? 'Enter your policy number' : null;
  }

  void _onPostalCodeChanged(String text){
    newUser.address.postalCd = text;
  }

  String _validatePostalCode(String val){
    return val.isEmpty ? 'Enter your postal code' : null;
  }
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
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
            autovalidate: autoValidate,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                //padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  textFieldWithIcon(disabled: disabled,labelText:'First name',labelStyle:style14,onChanged:_onFirstNameChanged,validator:_validateFirstName,imageLink: 'assets/images/person.png'),
                  SizedBox(
                    height: 15.0,
                  ),
                  textFieldWithIcon(disabled: disabled,labelText:'Last name',labelStyle:style14,onChanged:_onLastNameChanged,validator:_validateLastName,imageLink: 'assets/images/person.png'),
                  SizedBox(
                    height: 15.0,
                  ),

                  TextFormField(
                    onChanged: (text) {
                      newUser.phone = text;
                    },
                    validator: (val) =>
                    val.isEmpty ? 'Enter your phone number' : null,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: style14,
                      prefixIcon: const Icon(Icons.phone,color: Color(0xff011977)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011977)),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011977)),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011977)),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 15.0,
                  ),
                  textFieldWithIcon(disabled: disabled,labelText:'Policy Number',labelStyle:style14,onChanged:_onPolicyNumberChanged,validator:_validatePolicyNumber,imageLink: 'assets/images/policy.png'),

                  SizedBox(
                    height: 15.0,
                  ),
                  textFieldWithIcon(disabled: disabled,labelText:'Postal Code',labelStyle:style14,onChanged:_onPostalCodeChanged,validator:_validatePostalCode,imageLink: 'assets/images/postalcode.png'),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    onChanged: (text) {
                      newUser.email = text;
                    },
                    validator: (val) =>
                    val.isEmpty ? 'Enter your email' : null,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: style14,
                      prefixIcon: const Icon(Icons.email,color: Color(0xff011977)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011977)),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011977)),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011977)),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),



                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    onChanged: (text) {
                      newUser.password = text;
                    },
                      validator: (value) {
                        if (value.length == 0 || value.isEmpty) {
                          return ('Please enter your password');
                        }
                        if (value.length <6) {
                          return ('Your password should have at least 6 characters');
                        }
                        return null;
                      },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: style14,
                      prefixIcon: const ImageIcon(AssetImage('assets/images/password.png'),color: Color(0xff011977),),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011977)),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011977)),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011977)),
                        borderRadius: BorderRadius.circular(32.0),
                      ),


                    ),
                  ),
                  Container(
                    child: Row(

                      children: <Widget>[
                        SizedBox(

                          width: width*0.05,
                        ),
                        roundedGradientButton(disabled: disabled,text: 'Register',onPressed:_submitForm ),
                        SizedBox(
                          width: width*0.01,
                  ),
                      ],

                    ),


                  ),

                  SizedBox(
                    height: 15.0,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'To successfully register your',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                          children: <TextSpan>[
                        TextSpan(
                          text:
                              ' first name, last name, phone number, policy number and postal code',
                          style: TextStyle(color: Colors.blueAccent, fontSize: 12),
                        ),
                        TextSpan(

                          text: ' have to match our records',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        )
                      ])),
                  SizedBox(
                    height: 15.0,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'If these match, you will be able to signup using email/password or FaceId/Gmail etc.',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                          )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
