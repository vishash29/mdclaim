import 'package:flutter/material.dart';
import 'model/user.dart';
import 'model/claim.dart';
import 'services/claimServices.dart';
import 'package:flutter/cupertino.dart';
import 'common/widgets.dart';
import 'common/bottomNavBar.dart';
import 'dart:collection';
import 'newClaimPage5.dart';
import 'appHomePage.dart';

class NewClaimPage4 extends StatefulWidget {
  User user;
  Claim claim;

  NewClaimPage4({User user, Claim claim, Key key}) {
    this.user = user;
    this.claim = claim;
  }

  @override
  _NewClaimPage4SFW createState() => _NewClaimPage4SFW(user, claim);
}

class _NewClaimPage4SFW extends State<NewClaimPage4> {
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

  _NewClaimPage4SFW(User user, Claim claim) {
    this.user = user;
    this.claim = claim;
    if (claim.claimIdentifier !=null){
      formDisplayOnly=true;
    }
  }


  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  void onNextClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewClaimPage5(user:user,claim: claim)),
    );
  }
  void onPrevClick() {
    Navigator.pop(context);
  }

  void onWitnessName1Changed(String val) {
    claim.witnessName1 = val;
    print('set accidentdetails to $val');
  }

  String validateWitnessName1(String val) {
    return val.isEmpty ? 'Please enter the witness name' : null;
  }
  void onWitnessAddress1Changed(String val) {
    claim.witnessAddress1 = val;

  }
  String validateWitnessAddress1(String val) {
    return null;
  }

  void onWitnessName2Changed(String val) {
    claim.witnessName2 = val;
    //print('set accidentdetails to $val');
  }

  String validateWitnessName2(String val) {
    return val.isEmpty ? 'Please enter the witness name' : null;
  }
  void onWitnessAddress2Changed(String val) {
    claim.witnessAddress2 = val;

  }
  String validateWitnessAddress2(String val) {
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: createAppBar(screenTip: 'Step 4 Witness Details'),
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
                      textFieldWithoutIcon2(disabled: formDisplayOnly,initialValue:claim.witnessName1,labelText:'Name of Witness1',labelStyle:style14,onChanged:onWitnessName1Changed,validator:validateWitnessName1),
                      SizedBox(
                        height: 10.0,
                      ),
                      textAreaWithoutIcon(disabled: formDisplayOnly,initialValue:claim.witnessAddress1,labelText:'Address of Witness1',labelStyle:style14,onChanged:onWitnessAddress1Changed,validator:validateWitnessAddress1,maxLines: 3),
                      SizedBox(
                        height: 10.0,
                      ),
                      textFieldWithoutIcon2( disabled: formDisplayOnly,initialValue:claim.witnessName2,labelText:'Name of Witness2',labelStyle:style14,onChanged:onWitnessName2Changed,validator:validateWitnessName2),
                      SizedBox(
                        height: 10.0,
                      ),
                      textAreaWithoutIcon(disabled: formDisplayOnly,initialValue:claim.witnessAddress2,labelText:'Address of Witness2',labelStyle:style14,onChanged:onWitnessAddress2Changed,validator:validateWitnessAddress2,maxLines: 3),
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
