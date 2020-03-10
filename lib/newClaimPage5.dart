import 'package:flutter/material.dart';
import 'model/user.dart';
import 'model/claim.dart';
import 'services/claimServices.dart';
import 'package:flutter/cupertino.dart';
import 'common/widgets.dart';
import 'common/bottomNavBar.dart';
import 'dart:collection';
import 'model/thirdPartyInfo.dart';
import 'model/serviceReturn.dart';

class NewClaimPage5 extends StatefulWidget {
  User user;
  Claim claim;

  NewClaimPage5({User user, Claim claim, Key key}) {
    this.user = user;
    this.claim = claim;
  }

  @override
  _NewClaimPage5SFW createState() => _NewClaimPage5SFW(user, claim);
}

class _NewClaimPage5SFW extends State<NewClaimPage5> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle style16B = TextStyle(
      fontFamily: 'Monserrat', fontSize: 16.0, fontWeight: FontWeight.bold);
  TextStyle style16 = TextStyle(fontFamily: 'Monserrat', fontSize: 16.0);

  bool formDisplayOnly=false;
  User user;
  Claim claim;
  bool showSubmit=true;


  _NewClaimPage5SFW(User user, Claim claim) {
    this.user = user;
    this.claim = claim;
    if (claim.thirdPartyInfoList==null) {
      ThirdPartyInfo thirdPartyInfo = ThirdPartyInfo();
      claim.thirdPartyInfoList = [];
      claim.thirdPartyInfoList.add(thirdPartyInfo);
    }
    else{
      print('found third party info list');
      ThirdPartyInfo tpInfo=claim.thirdPartyInfoList[0];
      print('fn ${claim.thirdPartyInfoList[0].firstName}');
    }
    if (claim.claimIdentifier !=null){
      formDisplayOnly=true;
      showSubmit=false;
    }
  }



  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  void onSubmitClick() async {
    claim.policyNumber = user.policyNumber;
    claim.userIdentifier = user.mondIdentifier;
    claim.claimDate=DateTime.now();
    ServiceReturnModel returnModel =
        await saveClaimToMondCloud(user.email, claim);
    if (returnModel.isSuccess) {
      setState(() {
        showSubmit=false;
      });
      showMessage(returnModel.message, Colors.green);
    }
    else
      showMessage(returnModel.message, Colors.red);

    /*Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ClaimsHomePage(user:user)),
    );*/
  }

  void onPrevClick() {
    Navigator.pop(context);
  }

  void onTPFirstNameChanged(String val) {
    claim.thirdPartyInfoList[0].firstName = val;
  }

  String validateTPFirstName(String val) {
    return val.isEmpty ? 'Please enter the first name' : null;
  }

  void onTPLastNameChanged(String val) {
    claim.thirdPartyInfoList[0].lastName = val;
  }

  String validateTPLastName(String val) {
    return val.isEmpty ? 'Please enter the last name' : null;
  }

  void onTPAddress1Changed(String val) {
    claim.thirdPartyInfoList[0].address = val;
  }

  String validateTPAddress1(String val) {
    return null;
  }

  void onTPInsurerChanged(String val) {
    claim.thirdPartyInfoList[0].insurer = val;
  }

  String validateTPInsurer(String val) {
    return val.isEmpty ? 'Please enter the insurer name' : null;
  }

  void onTPMakeModelChanged(String val) {
    claim.thirdPartyInfoList[0].makeAndModel = val;
  }

  String validateTPMakeModel(String val) {
    return null;
  }

  void onTPDamagesChanged(String val) {
    claim.thirdPartyInfoList[0].damages = val;
  }

  String validateTPDamages(String val) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: createAppBar(screenTip: 'Step 5 Other party report'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 35,
                        width: width * .40,
                        child: textFieldWithoutIcon2(
                          disabled: formDisplayOnly,
                          initialValue: claim.thirdPartyInfoList[0].firstName,
                            labelText: 'Other party first name',
                            labelStyle: style14,
                            onChanged: onTPFirstNameChanged,
                            validator: validateTPFirstName),
                      ),
                      SizedBox(
                        height: 35,
                        width: width * .02,
                      ),
                      SizedBox(
                        height: 35,
                        width: width * .40,
                        child: textFieldWithoutIcon2(
                            disabled: formDisplayOnly,
                          initialValue: claim.thirdPartyInfoList[0].lastName,
                            labelText: 'Last name',
                            labelStyle: style14,
                            onChanged: onTPLastNameChanged,
                            validator: validateTPLastName),
                      ),
                      //textFieldWithoutIcon(labelText:'Last Name',labelStyle:style14,onChanged:onWitnessName1Changed,validator:validateWitnessName1),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  textAreaWithoutIcon(
                      disabled: formDisplayOnly,
                     initialValue:claim.thirdPartyInfoList[0].address,
                      labelText: 'Other party address',
                      labelStyle: style14,
                      onChanged: onTPAddress1Changed,
                      validator: validateTPAddress1,
                      maxLines: 3),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                      height: 35,
                      child: textFieldWithoutIcon2(
                          disabled: formDisplayOnly,
                        initialValue: claim.thirdPartyInfoList[0].insurer,
                          labelText: 'Other party Insurer',
                          labelStyle: style14,
                          onChanged: onTPInsurerChanged,
                          validator: validateTPInsurer)),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 35,
                    child: textFieldWithoutIcon2(
                        disabled: formDisplayOnly,
                        initialValue:claim.thirdPartyInfoList[0].makeAndModel,
                        labelText: 'Other party Make/Model',
                        labelStyle: style14,
                        onChanged: onTPMakeModelChanged,
                        validator: validateTPMakeModel),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  textAreaWithoutIcon(
                      disabled: formDisplayOnly,
                    initialValue: claim.thirdPartyInfoList[0].damages,
                      labelText: 'Damages',
                      labelStyle: style14,
                      onChanged: onTPDamagesChanged,
                      validator: validateTPDamages,
                      maxLines: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      roundedGradientButton(
                          onPressed: onPrevClick,
                          text: 'Previous',
                          style: style14,
                          width: 150.0),
                      showSubmit==true ?
                      roundedGradientButton(
                          onPressed: onSubmitClick,
                          text: 'Submit',
                          style: style14,
                          width: 150.0):SizedBox(),
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
          BottomNavBar(context, user).createBottomNavigationBar('claims'),
    );
  }



}

