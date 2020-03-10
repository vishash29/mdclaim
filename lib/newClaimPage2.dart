import 'package:flutter/material.dart';
import 'model/user.dart';
import 'model/claim.dart';
import 'package:flutter/cupertino.dart';
import 'common/widgets.dart';
import 'common/bottomNavBar.dart';
import 'dart:collection';
import 'newClaimPage3.dart';

class NewClaimPage2 extends StatefulWidget {
  User user;
  Claim claim;

  NewClaimPage2({User user, Claim claim, Key key}) {
    this.user = user;
    this.claim = claim;
  }

  @override
  _NewClaimPage2SFW createState() => _NewClaimPage2SFW(user, claim);
}

class _NewClaimPage2SFW extends State<NewClaimPage2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle style16B = TextStyle(
      fontFamily: 'Monserrat', fontSize: 16.0, fontWeight: FontWeight.bold);
  TextStyle style16 = TextStyle(fontFamily: 'Monserrat', fontSize: 16.0);
  List<DropdownMenuItem<String>> _whoWasAtFaultItems = List();

  User user;
  Claim claim;
  bool formDisplayOnly=false;

  _NewClaimPage2SFW(User user, Claim claim) {
    this.user = user;
    this.claim = claim;
    _initDropdown();
    if (claim.claimIdentifier !=null){
      formDisplayOnly=true;
    }
  }

  void _initDropdown(){
    LinkedHashMap<String, String> _atFaultValues = LinkedHashMap();
    _atFaultValues['ME'] = 'Myself';
    _atFaultValues['OP'] = 'Other party';
    _atFaultValues['BT'] = 'Both';
    _atFaultValues['TP'] = 'Third party';
    addToDropdown(_atFaultValues, _whoWasAtFaultItems,style14);
  }
  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }
  void onAtFaultClick(newValue) {
    setState(() {
      claim.whoWasAtFault = newValue;
      print('selected $newValue');
      //state.didChange(newValue);
    });
  }
  void onNextClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewClaimPage3(user:user,claim: claim)),
    );
  }
  void onPrevClick() {
    Navigator.pop(context);
  }

  void onAccidentDetailsChanged(String val) {
    claim.accidentDetails = val;
  //  print('set accidentdetails to $val');
  }

  String validateAccidentDetails(String val) {
    return val.isEmpty ? 'Please enter the accident details' : null;
  }
  void onInjuriesSustainedChanged(String val) {
    claim.injuriesSustained = val;

  }

  String validateInjuriesSustained(String val) {
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: createAppBar(screenTip: 'Step 2 Accident Details'),
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
                      textAreaWithoutIcon(disabled:formDisplayOnly,initialValue:claim.accidentDetails,labelText:'Accident details',labelStyle:style14,onChanged:onAccidentDetailsChanged,validator:validateAccidentDetails,maxLines: 4),
                      SizedBox(
                        height: 10.0,
                      ),
                      textAreaWithoutIcon(disabled:formDisplayOnly,initialValue:claim.injuriesSustained,labelText:'Injuries sustained',labelStyle:style14,onChanged:onInjuriesSustainedChanged,validator:validateInjuriesSustained,maxLines: 3),
                      SizedBox(
                        height: 10.0,
                      ),
                      createTakenToHospitalUseSwitch(),
                      SizedBox(
                        height: 10.0,
                      ),
                      createDropdown(
                          disabled:formDisplayOnly,
                          label: 'Who do you think was at fault?',
                          isEmptyField: claim.whoWasAtFault,
                          valueField: claim.whoWasAtFault,
                          onClick: onAtFaultClick,
                          items: _whoWasAtFaultItems),

                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          roundedGradientButton(
                              onPressed: onPrevClick, text: 'Previous', style: style14,width: 150.0),

                          roundedGradientButton(
                              onPressed: onNextClick, text: 'Next', style: style14,width: 150.0),
                        ],
                      ),

                      SizedBox(
                        height: 15.0,
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

  Widget createTakenToHospitalUseSwitch() {
    return MergeSemantics(
      child: ListTile(
        title: Text(
          'Were you taken to hospital?',
          style: style14,
        ),
        trailing: CupertinoSwitch(
          value: claim.wasTakenToHospital,
          onChanged: (bool value) {
            setState(() {
              claim.wasTakenToHospital = value;
            });
          },
        ),
        onTap: () {
          setState(() {
            claim.wasTakenToHospital = !claim.wasTakenToHospital;
          });
        },
      ),
    );
  }

 /* void onItemTapped(int index) {
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

/*

                    TextFormField(
                      obscureText: false,
                      maxLines: 4,
                      style: style16,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (text) {
                        claim.accidentDetails = text;
                      },
                      validator: (val) => val.isEmpty
                          ? 'Please enter the accident details'
                          : null,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          labelText: 'Accident details',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                    ),
 */

/*
                  SizedBox(
                    height: 15.0,
                  ),
                  wasReportedToPolice(),
                  claim.wasReportedToPolice == true ||
                          claim.wasReportedToWardens == true
                      ? TextFormField(
                          obscureText: false,
                          style: style16,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (text) {
                            user.email = text.trim().toLowerCase();
                          },
                          validator: (val) => val.isEmpty
                              ? 'Please enter the report number'
                              : null,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: 'Report Number',
                              hintStyle: style14,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0))),
                        )
                      : Container(),

 */
