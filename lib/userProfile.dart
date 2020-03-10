import 'package:flutter/material.dart';
import 'model/user.dart';
import 'package:flutter/cupertino.dart';
import 'common/widgets.dart';
import 'common/bottomNavBar.dart';
import 'package:flutter/services.dart';


class UserProfilePage extends StatefulWidget {
  User user;

  UserProfilePage({User user, Key key}) {
    this.user = user;
  }

  @override
  _UserProfilePageSFW createState() => _UserProfilePageSFW(user);
}

class _UserProfilePageSFW extends State<UserProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle style16B = TextStyle(
      fontFamily: 'Monserrat', fontSize: 16.0, fontWeight: FontWeight.bold);
  TextStyle style16 = TextStyle(fontFamily: 'Monserrat', fontSize: 16.0);
  List<DropdownMenuItem<String>> _whoWasAtFaultItems = List();

  User user;
  bool formDisplayOnly=true;

  _UserProfilePageSFW(User user) {
    this.user = user;
  }


  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  void _saveForm() {

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
          appBar: createAppBar(screenTip: 'Your profile'),
          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
                child: ListView(children: <Widget>[
              Card(
                color: Colors.grey[150],
                margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      textFieldWithIcon(disabled: formDisplayOnly,initialValue:user.firstName,labelText:'First name',labelStyle:style14,onChanged:_onFirstNameChanged,validator:_validateFirstName,imageLink: 'assets/images/person.png'),
                      SizedBox(
                        height: 10.0,
                      ),
                      textFieldWithIcon(disabled: formDisplayOnly,initialValue:user.lastName,labelText:'Last name',labelStyle:style14,onChanged:_onLastNameChanged,validator:_validateLastName,imageLink: 'assets/images/person.png'),
                      SizedBox(
                        height: 10.0,
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
                        height: 10.0,
                      ),
                      textFieldWithIcon(disabled: formDisplayOnly,initialValue:user.policyNumber,labelText:'Policy Number',labelStyle:style14,onChanged:_onPolicyNumberChanged,validator:_validatePolicyNumber,imageLink: 'assets/images/policy.png'),
                      SizedBox(
                        height: 15.0,
                      ),
                      textFieldWithIcon(disabled: formDisplayOnly,initialValue:user.address.postalCd,labelText:'Postal Code',labelStyle:style14,onChanged:_onPostalCodeChanged,validator:_validatePostalCode,imageLink: 'assets/images/postalcode.png'),
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

                        width: width*0.15,
                        child: roundedGradientButton(disabled: formDisplayOnly,text: 'Save',onPressed:_saveForm ),
                      ),

                    ],
                  ),
                ),
              )
            ])),
          ),
          backgroundColor: Colors.grey,
          bottomNavigationBar:
          BottomNavBar(context,user). createBottomNavigationBar('claims'),
        );
  }


}


