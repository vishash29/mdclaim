import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mdclaim/common/widgets.dart';
import 'model/user.dart';

import 'common/bottomNavBar.dart';

class UserProfilePage extends StatefulWidget {
  User user;

  UserProfilePage({User user, Key key}) {
    this.user = user;
  }

  @override
  _UserProfilePageState createState() => _UserProfilePageState(user);
}

class _UserProfilePageState extends State<UserProfilePage> with AutomaticKeepAliveClientMixin<UserProfilePage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  bool autoValidate = false;
  User user;
  bool disabled=true;

  @override
  bool get wantKeepAlive => true;

  _UserProfilePageState(User user) {
    this.user = user;

  }
  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input.trim());
  }

  void _submitForm() async {

  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {

    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: color,content: Text(message),
    ));

  }


  void _onFirstNameChanged(String text){
    user.firstName = text;
  }

  String _validateFirstName(String val){
    return val.isEmpty ? 'Please enter your first name' : null;
  }
  void _onLastNameChanged(String text){
    user.lastName = text;
  }

  String _validateLastName(String val){
    return val.isEmpty ? 'Please enter your last name' : null;
  }
  void _onPolicyNumberChanged(String text){
    user.policyNumber = text;
  }

  String _validatePolicyNumber(String val){
    return val.isEmpty ? 'Enter your policy number' : null;
  }

  void _onPostalCodeChanged(String text){
    user.address.postalCd = text;
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
                  textFieldWithIcon(disabled: disabled,initialValue:user.firstName,labelText:'First name',labelStyle:style14,onChanged:_onFirstNameChanged,validator:_validateFirstName,imageLink: 'assets/images/person.png'),
                  SizedBox(
                    height: 15.0,
                  ),
                  textFieldWithIcon(disabled: disabled,initialValue:user.lastName,labelText:'Last name',labelStyle:style14,onChanged:_onLastNameChanged,validator:_validateLastName,imageLink: 'assets/images/person.png'),
                  SizedBox(
                    height: 15.0,
                  ),

                  TextFormField(
                    initialValue: user.phone,
                    onChanged: (text) {
                      user.phone = text;
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
                  textFieldWithIcon(disabled: disabled,initialValue:user.policyNumber,labelText:'Policy Number',labelStyle:style14,onChanged:_onPolicyNumberChanged,validator:_validatePolicyNumber,imageLink: 'assets/images/policy.png'),

                  SizedBox(
                    height: 15.0,
                  ),
                  textFieldWithIcon(disabled: disabled,initialValue:user.address.postalCd,labelText:'Postal Code',labelStyle:style14,onChanged:_onPostalCodeChanged,validator:_validatePostalCode,imageLink: 'assets/images/postalcode.png'),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    onChanged: (text) {
                      user.email = text;
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

                  Container(
                    child: Row(

                      children: <Widget>[
                        SizedBox(

                          width: width*0.05,
                        ),
                        roundedGradientButton(disabled: disabled,text: 'Save',onPressed:_submitForm ),
                        SizedBox(
                          width: width*0.01,
                  ),
                      ],

                    ),


                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey,
      bottomNavigationBar:
      BottomNavBar(context, user).createBottomNavigationBar('claims'),
    );
  }
}
