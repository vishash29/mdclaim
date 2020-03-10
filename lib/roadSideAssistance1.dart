import 'package:flutter/material.dart';
import 'model/user.dart';

import 'package:flutter/cupertino.dart';
import 'dart:collection';
import 'common/widgets.dart';
import 'common/bottomNavBar.dart';
import 'roadSideAssistance2.dart';
import 'package:flutter/services.dart';

class RoadSideAssistance1 extends StatefulWidget {
  User user;

  RoadSideAssistance1({User user, Key key}) {
    this.user = user;
  }

  @override
  _RoadSideAssistance1SFW createState() => _RoadSideAssistance1SFW(
        user,
      );
}

class _RoadSideAssistance1SFW extends State<RoadSideAssistance1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle style16B = TextStyle(
      fontFamily: 'Monserrat', fontSize: 16.0, fontWeight: FontWeight.bold);
  TextStyle style16 = TextStyle(fontFamily: 'Monserrat', fontSize: 16.0);
  List<DropdownMenuItem<String>> _ServiceNeededItems = List();
  String serviceType = '1';

  User user;
  int selectedIndex = 0;

  _RoadSideAssistance1SFW(User user) {
    this.user = user;
    initDropDowns();
    print('user phone ${user.phone}');
  }

  void initDropDowns() {
    LinkedHashMap<String, String> _serviceItems = LinkedHashMap();
    _serviceItems['1'] = 'Battery Boost';
    _serviceItems['2'] = 'Tire replacement';
    _serviceItems['3'] = 'Towing';
    _serviceItems['4'] = 'Other';
    addToDropdown(_serviceItems, _ServiceNeededItems, style14);
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  void onNextClick() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RoadSideAssistance2(user: user)),
      );
    } else {
      print('will show message');
      showMessage('Please review and correct');
    }
  }

  void onServiceClick(newValue) {
    setState(() {
      print('selected $newValue');
      //state.didChange(newValue);
    });
  }

  String validateLicenseDetails(String val) {
    return val.isEmpty ? 'Please enter the license plate number' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(screenTip: 'Roadside Assistance'),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
            child: Form(
                key: _formKey,
                autovalidate: false,
                child: ListView(children: <Widget>[
                  Card(
                    color: Colors.grey[150],
                    margin:
                        new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
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
                          createDropdown(
                              label: 'Select the service you need',
                              isEmptyField: serviceType,
                              valueField: serviceType,
                              onClick: onServiceClick,
                              items: _ServiceNeededItems,
                              style: style14),
                          SizedBox(
                            height: 10.0,
                          ),
                          textFieldWithoutIcon(
                            labelText: 'Your car license plate',
                            labelStyle: style14,
                            onChanged: onServiceClick,
                            validator: validateLicenseDetails,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            initialValue: user.phone,
                            validator: (val) => val.isEmpty
                                ? 'Please enter your phone number'
                                : null,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Your phone number',
                              labelStyle: style14,
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
                          RichText(
                              text: TextSpan(
                                  text:
                                      'In the next page, please choose your location.',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                  children: <TextSpan>[
                                TextSpan(
                                  text:
                                      ' The towing company will call you to confirm the details.',
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 12),
                                ),
                                TextSpan(
                                  text:
                                      ' Switch on the hazard light, pull over and wait',
                                  style:
                                      TextStyle(color: Colors.red, fontSize: 12),
                                )
                              ])),
                          SizedBox(
                            height: 15.0,
                          ),
                          roundedGradientButton(
                              onPressed: onNextClick,
                              text: 'Next',
                              style: style14),
                        ],
                      ),
                    ),
                  )
                ]))),
      ),
      backgroundColor: Colors.grey,
      bottomNavigationBar:
          BottomNavBar(context, user).createBottomNavigationBar('roadSide'),
    );
  }

/*void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      print('tapped $index');
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClaimsHomePage(user: user)),
        );
      }
    });
  }*/
}
