import 'package:flutter/material.dart';
import 'model/user.dart';
import 'model/claim.dart';
import 'package:flutter/cupertino.dart';
import 'dart:collection';
import 'common/widgets.dart';
import 'common/bottomNavBar.dart';
import 'common/dateTimeUtils.dart';
import 'common/keyValue.dart';
import 'newClaimPage2.dart';

class NewClaimPage1 extends StatefulWidget {
  User user;
  Claim claim;

  NewClaimPage1({User user, Claim claim, Key key}) {
    this.user = user;
    this.claim = claim;
  }

  @override
  _NewClaimPage1SFW createState() => _NewClaimPage1SFW(user, claim);
}

class _NewClaimPage1SFW extends State<NewClaimPage1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle style12W =
      TextStyle(fontFamily: 'Monserrat', fontSize: 12.0, color: Colors.white);
  TextStyle style16B = TextStyle(
      fontFamily: 'Monserrat', fontSize: 16.0, fontWeight: FontWeight.bold);
  TextStyle style16 = TextStyle(fontFamily: 'Monserrat', fontSize: 16.0);
  List<DropdownMenuItem<String>> _stateOfRoadItems = List();
  List<DropdownMenuItem<String>> _speedUOMItems = List();
  List<DropdownMenuItem<String>> _typeOfClaimItems = List();
  LinkedHashMap<String, String> _stateOfRoad = LinkedHashMap();
  List<KeyValueModel> _stateOfRoadL;

  User user;
  Claim claim;

  //int selectedIndex = 0;
  String _collisionImage;
  Color _collisionImageColor;
  Color _collisionTextColor;
  String _fireImage;
  Color _fireImageColor;
  Color _fireTextColor;
  String _hitRunImage;
  Color _hitRunImageColor;
  Color _hitRunTextColor;
  String _windshieldImage;
  Color _windshieldImageColor;
  Color _windshieldTextColor;
  String _theftImage;
  Color _theftImageColor;
  Color _theftTextColor;
  String _otherImage;
  Color _otherImageColor;
  Color _otherTextColor;
  bool formDisplayOnly = false;

  _NewClaimPage1SFW(User user, Claim claim) {
    this.user = user;
    this.claim = claim;

    //laim.accidentDateTimeS = ' ';
    print('going to init dropdowns');
    initDropDowns();
    initClaimTypeImage();
    if (claim.claimIdentifier != null) {
      formDisplayOnly = true;
    }
    print('*******Display Mode $formDisplayOnly');
  }

  void formatDate(DateTime newdate) {
    DateUtils dateUtils = DateUtils();
    claim.accidentDateTime = newdate;
    setState(() {
      claim.accidentDateTimeS = dateUtils.getFormattedDateWithTime(newdate);
      print('formatted ${claim.accidentDateTimeS}');
    });
  }

  void onTypeOfClaimClick(newValue) {
    setState(() {
      claim.claimType = newValue;
      print('selected $newValue');
      //state.didChange(newValue);
    });
  }

  void onStateOfRoadClick(newValue) {
    setState(() {
      claim.stateOfRoad = newValue;
      print('selected $newValue');
      //state.didChange(newValue);
    });
  }

  void onSpeedUOMClick(newValue) {
    setState(() {
      claim.vehicleSpeedUOM = newValue;
      print('selected $newValue');
      //state.didChange(newValue);
    });
  }

  void onVehicleSpeedChanged(String val) {
    claim.vehicleSpeedS = val;
    print('set vehicleSpeedS to $val');
  }

  String validateVehicleSpeed(String val) {
    return val.isEmpty ? 'Please enter the vehicle speed' : null;
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  void onNextClick() {
    if (claim.accidentDateTime==null){
      showMessage('Please select the date/time when this incident took place',Colors.red);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NewClaimPage2(user: user, claim: claim)),
    );
  }

  void initDropDowns() {
    _stateOfRoadL = [
      KeyValueModel(key: 'DOWN', value: 'Downhill'),
      KeyValueModel(key: 'DRY', value: 'Dry'),
      KeyValueModel(key: 'FL', value: 'Flat'),
      KeyValueModel(key: 'RG', value: 'Rough'),
      KeyValueModel(key: 'SM', value: 'Smooth'),
      KeyValueModel(key: 'UP', value: 'Uphill'),
      KeyValueModel(key: 'WET', value: 'Wet')
    ];
    _stateOfRoad['DOWN'] = 'Downhill';
    _stateOfRoad['DRY'] = 'Dry';
    _stateOfRoad['FL'] = 'Flat';
    _stateOfRoad['RG'] = 'Rough';
    _stateOfRoad['SM'] = 'Smooth';
    _stateOfRoad['UP'] = 'Uphill';
    _stateOfRoad['WET'] = 'Wet';
    addToDropdown(_stateOfRoad, _stateOfRoadItems, style14);

    LinkedHashMap<String, String> _speedUOM = LinkedHashMap();
    _speedUOM['KMH'] = 'KM per hour';
    _speedUOM['MPH'] = 'Miles per hour';
    addToDropdown(_speedUOM, _speedUOMItems, style14);

    LinkedHashMap<String, String> _typeOfClaim = LinkedHashMap();
    _typeOfClaim['01'] = 'Collision';
    _typeOfClaim['02'] = 'Fire';
    _typeOfClaim['03'] = 'Hit and run';
    _typeOfClaim['04'] = 'Windshield';
    _typeOfClaim['05'] = 'Theft';
    _typeOfClaim['06'] = 'Other';
    addToDropdown(_typeOfClaim, _typeOfClaimItems, style14);
    //claim.claimType = '01';
  }

  void _showDateTime() {
    DateTime currentTime = DateTime.now();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                height: MediaQuery.of(context).size.height / 3,
                child: CupertinoDatePicker(
                    initialDateTime: DateTime(currentTime.year,
                        currentTime.month, currentTime.day, currentTime.hour),
                    onDateTimeChanged: (DateTime newdate) {
                      print(newdate);
                      formatDate(newdate);
                    },
                    use24hFormat: true,
                    maximumDate: DateTime(currentTime.year, currentTime.month,
                        currentTime.day, currentTime.hour, currentTime.minute),
                    minimumYear: 2020,
                    maximumYear: 2021,
                    minuteInterval: 1,
                    mode: CupertinoDatePickerMode.dateAndTime)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: createAppBar(screenTip: 'Step 1 - Incident Report'),
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
                  claim.claimIdentifier==null?
                  roundedGradientButton(
                      disabled: formDisplayOnly,
                      onPressed: _showDateTime,
                      text: 'When did this incident occur?',
                      style: style14): Text('Claim Number ${claim.claimIdentifier}',style: style16B,),
                  SizedBox(
                    height: 10.0,
                  ),
                  claim.accidentDateTimeS == ''
                      ? SizedBox():
                  RichText(
                      text: TextSpan(
                          text: 'Accident Date/Time: ',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                                text: claim.accidentDateTimeS,
                                style: TextStyle(fontFamily: 'Monserrat',color: Colors.red, fontSize: 15)),
                          ])),
                  createBusinessPersonalUseSwitch(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      createTypeOfClaim('Collision', '01', _collisionImage,
                          _collisionImageColor, _collisionTextColor),
                      createTypeOfClaim('Fire', '02', _fireImage, _fireImageColor,
                          _fireTextColor),
                      createTypeOfClaim('Hit & Run', '03', _hitRunImage,
                          _hitRunImageColor, _hitRunTextColor),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      createTypeOfClaim('Windshield', '04', _windshieldImage,
                          _windshieldImageColor, _windshieldTextColor),
                      createTypeOfClaim('Theft', '05', _theftImage,
                          _theftImageColor, _theftTextColor),
                      createTypeOfClaim('Other', '06', _otherImage,
                          _otherImageColor, _otherTextColor),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 55,
                    child: createDropdown(
                        disabled: formDisplayOnly,
                        label: 'State of Road',
                        isEmptyField: claim.stateOfRoad,
                        valueField: claim.stateOfRoad,
                        onClick: onStateOfRoadClick,
                        items: _stateOfRoadItems,
                        style: style14),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        height: 35,
                        width: width * 0.4,
                        child: textFieldWithoutIcon2(
                            disabled: formDisplayOnly,
                            keyboardType:TextInputType.number,
                            initialValue: claim.vehicleSpeedS,
                            labelText: 'Vehicle speed',
                            labelStyle: style14,
                            onChanged: onVehicleSpeedChanged,
                            validator: validateVehicleSpeed),
                      ),
                      Flexible(
                        child: _segmentedSpeedUOM(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  roundedGradientButton(
                      onPressed: onNextClick, text: 'Next', style: style14),
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

  Widget createBusinessPersonalUseSwitch() {
    return MergeSemantics(
      child: ListTile(
        enabled: formDisplayOnly,
        title: Text(
          'Was the car used for business?',
          style: style14,
        ),
        trailing: CupertinoSwitch(
          value: claim.wasBusinessUse,
          onChanged: formDisplayOnly == true
              ? null
              : (bool value) {
                  setState(() {
                    claim.wasBusinessUse = value;
                  });
                },
        ),
        onTap: () {
          setState(() {
            claim.wasBusinessUse = !claim.wasBusinessUse;
          });
        },
      ),
    );
  }

  Widget createTypeOfClaim(String label, String claimType, String imageName,
      Color btnColor, Color textBorderColor) {
    return Container(
        width: 85,
        child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            onPressed: () {
              print('Button Clicked ' + claimType);
              claim.claimType = claimType;
              changeClaimTypeIcon(claimType);
            },
            textColor: Colors.white,
            color: btnColor,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(4, 0, 10, 0),
                      child: Image.asset(
                          //getClaimTypeAssetName(claimType),
                          imageName),
                    ),
                    Container(
                      color: textBorderColor,
                      padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                      child: Text(
                        label,
                        style: TextStyle(
                            fontFamily: 'Monserrat',
                            fontSize: 12.0,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ))));
  }

  void changeClaimTypeIcon(String _newClaimType) {
    setState(() {
      _setClaimTypeAssetName(_newClaimType);
    });
  }

  void initClaimTypeImage() {
    print('initClaimTypeImage $claim');
    _setClaimTypeAssetName(claim.claimType);
  }

  void _setClaimTypeAssetName(String claimType) {
    if (claimType.compareTo('01') == 0) {
      _collisionImage = 'assets/images/typeCollisionActive.png';
      //others
      _fireImage = 'assets/images/typeFireInactive.png';
      _hitRunImage = 'assets/images/typeHitRunInactive.png';
      _windshieldImage = 'assets/images/typeWindshieldInactive.png';
      _theftImage = 'assets/images/typeTheftInactive.png';
      _otherImage = 'assets/images/typeOtherInactive.png';

      _collisionImageColor = Color(BORDERCOLOR);
      _collisionTextColor = Color(BORDERCOLOR);
      //others
      _fireImageColor = Colors.grey;
      _fireTextColor = Colors.grey;

      _hitRunImageColor = Colors.grey;
      _hitRunTextColor = Colors.grey;

      _windshieldImageColor = Colors.grey;
      _windshieldTextColor = Colors.grey;

      _theftImageColor = Colors.grey;
      _theftTextColor = Colors.grey;

      _otherImageColor = Colors.grey;
      _otherTextColor = Colors.grey;
      return;
    }
    if (claimType.compareTo('02') == 0) {
      _fireImage = 'assets/images/typeFireActive.png';
      //others
      _collisionImage = 'assets/images/typeCollisionInactive.png';
      _hitRunImage = 'assets/images/typeHitRunInactive.png';
      _windshieldImage = 'assets/images/typeWindshieldInactive.png';
      _theftImage = 'assets/images/typeTheftInactive.png';
      _otherImage = 'assets/images/typeOtherInactive.png';

      _fireImageColor = Color(BORDERCOLOR);
      _fireTextColor = Color(BORDERCOLOR);

      _collisionImageColor = Colors.grey;
      _collisionTextColor = Colors.grey;

      _hitRunImageColor = Colors.grey;
      _hitRunTextColor = Colors.grey;

      _windshieldImageColor = Colors.grey;
      _windshieldTextColor = Colors.grey;

      _theftImageColor = Colors.grey;
      _theftTextColor = Colors.grey;

      _otherImageColor = Colors.grey;
      _otherTextColor = Colors.grey;
      return;
    }
    if (claimType.compareTo('03') == 0) {
      _hitRunImage = 'assets/images/typeHitRunActive.png';
      //others
      _collisionImage = 'assets/images/typeCollisionInactive.png';
      _fireImage = 'assets/images/typeFireInactive.png';
      _windshieldImage = 'assets/images/typeWindshieldInactive.png';
      _theftImage = 'assets/images/typeTheftInactive.png';
      _otherImage = 'assets/images/typeOtherInactive.png';

      _hitRunImageColor = Color(BORDERCOLOR);
      _hitRunTextColor = Color(BORDERCOLOR);

      _collisionImageColor = Colors.grey;
      _collisionTextColor = Colors.grey;

      _fireImageColor = Colors.grey;
      _fireTextColor = Colors.grey;

      _windshieldImageColor = Colors.grey;
      _windshieldTextColor = Colors.grey;

      _theftImageColor = Colors.grey;
      _theftTextColor = Colors.grey;

      _otherImageColor = Colors.grey;
      _otherTextColor = Colors.grey;
      return;
    }

    if (claimType.compareTo('04') == 0) {
      _windshieldImage = 'assets/images/typeWindshieldActive.png';
      //others
      _collisionImage = 'assets/images/typeCollisionInactive.png';
      _fireImage = 'assets/images/typeFireInactive.png';
      _hitRunImage = 'assets/images/typeHitRunInactive.png';
      _theftImage = 'assets/images/typeTheftInactive.png';
      _otherImage = 'assets/images/typeOtherInactive.png';

      _windshieldImageColor = Color(BORDERCOLOR);
      _windshieldTextColor = Color(BORDERCOLOR);

      _collisionImageColor = Colors.grey;
      _collisionTextColor = Colors.grey;

      _fireImageColor = Colors.grey;
      _fireTextColor = Colors.grey;

      _hitRunImageColor = Colors.grey;
      _hitRunTextColor = Colors.grey;

      _theftImageColor = Colors.grey;
      _theftTextColor = Colors.grey;

      _otherImageColor = Colors.grey;
      _otherTextColor = Colors.grey;
      return;
    }

    if (claimType.compareTo('05') == 0) {
      _theftImage = 'assets/images/typeTheftActive.png';
      //others
      _collisionImage = 'assets/images/typeCollisionInactive.png';
      _fireImage = 'assets/images/typeFireInactive.png';
      _windshieldImage = 'assets/images/typeWindshieldInactive.png';
      _hitRunImage = 'assets/images/typeHitRunInactive.png';
      _otherImage = 'assets/images/typeOtherInactive.png';

      _theftImageColor = Color(BORDERCOLOR);
      _theftTextColor = Color(BORDERCOLOR);

      _collisionImageColor = Colors.grey;
      _collisionTextColor = Colors.grey;

      _fireImageColor = Colors.grey;
      _fireTextColor = Colors.grey;

      _hitRunImageColor = Colors.grey;
      _hitRunTextColor = Colors.grey;

      _windshieldImageColor = Colors.grey;
      _windshieldTextColor = Colors.grey;

      _otherImageColor = Colors.grey;
      _otherTextColor = Colors.grey;
      return;
    }

    if (claimType.compareTo('06') == 0) {
      _otherImage = 'assets/images/typeOtherActive.png';
      //others
      _collisionImage = 'assets/images/typeCollisionInactive.png';
      _fireImage = 'assets/images/typeFireInactive.png';
      _windshieldImage = 'assets/images/typeWindshieldInactive.png';
      _hitRunImage = 'assets/images/typeHitRunInactive.png';
      _theftImage = 'assets/images/typeTheftInactive.png';

      _otherImageColor = Color(BORDERCOLOR);
      _otherTextColor = Color(BORDERCOLOR);

      _collisionImageColor = Colors.grey;
      _collisionTextColor = Colors.grey;

      _fireImageColor = Colors.grey;
      _fireTextColor = Colors.grey;

      _hitRunImageColor = Colors.grey;
      _hitRunTextColor = Colors.grey;

      _theftImageColor = Colors.grey;
      _theftTextColor = Colors.grey;

      _windshieldImageColor = Colors.grey;
      _windshieldTextColor = Colors.grey;
      return;
    }
  }

  String getClaimTypeAssetName(String claimType) {
    if (claimType.compareTo('01') == 0) {
      if (claim.claimType.compareTo('01') == 0) {
        _collisionImageColor = Color(BORDERCOLOR);
        _collisionTextColor = Color(BORDERCOLOR);
        return 'assets/images/typeCollisionActive.png';
      }
      _collisionImageColor = Colors.grey;
      _collisionTextColor = Color(BORDERCOLOR);
      return 'assets/images/typeCollisionInactive.png';
    }
    if (claimType.compareTo('02') == 0) {
      if (claim.claimType.compareTo('02') == 0) {
        _fireImageColor = Color(BORDERCOLOR);
        _fireTextColor = Color(BORDERCOLOR);
        return 'assets/images/typeFireActive.png';
      }
      _fireImageColor = Colors.grey;
      return 'assets/images/typeFireInactive.png';
    }
    if (claimType.compareTo('03') == 0) {
      if (claim.claimType.compareTo('03') == 0) {
        _hitRunImageColor = Color(BORDERCOLOR);
        _hitRunTextColor = Color(BORDERCOLOR);
        return 'assets/images/typeHitRunActive.png';
      }
      return 'assets/images/typeHitRunInactive.png';
    }
    if (claimType.compareTo('04') == 0) {
      if (claim.claimType.compareTo('04') == 0) {
        return 'assets/images/typeWindshieldActive.png';
      }
      return 'assets/images/typeWindshieldInactive.png';
    }
    if (claimType.compareTo('05') == 0) {
      if (claim.claimType.compareTo('05') == 0) {
        return 'assets/images/typeTheftActive.png';
      }
      return 'assets/images/typeTheftInactive.png';
    }
    if (claimType.compareTo('06') == 0) {
      if (claim.claimType.compareTo('06') == 0) {
        return 'assets/images/typeOtherActive.png';
      }
      return 'assets/images/typeOtherInactive.png';
    }
    return null;
  }

  Widget wasReportedToPolice() {
    return MergeSemantics(
      child: ListTile(
        title: Text(
          'Was reported to Police',
          style: style14,
        ),
        trailing: CupertinoSwitch(
          value: claim.wasReportedToPolice,
          onChanged: (bool value) {
            setState(() {
              claim.wasReportedToPolice = value;
            });
          },
        ),
        onTap: () {
          setState(() {
            claim.wasReportedToPolice = !claim.wasReportedToPolice;
          });
        },
      ),
    );
  }

  Widget _segmentedSpeedUOM() {
    return Container(
      width: 500,
      child: CupertinoSegmentedControl<int>(
        selectedColor: Color(0xff011977),
        borderColor: Colors.black,
        children: {
          1: Text('KMH'),
          2: Text('MPH'),
        },
        onValueChanged: (int val) {
          setState(() {
            claim.speedUOM = val;
          });
        },
        groupValue: claim.speedUOM,
      ),
    );
  }
}
