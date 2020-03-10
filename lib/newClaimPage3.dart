import 'package:flutter/material.dart';
import 'model/user.dart';
import 'model/claim.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'common/widgets.dart';
import 'common/bottomNavBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'newClaimPage4.dart';
import 'package:geocoder/geocoder.dart';

class NewClaimPage3 extends StatefulWidget {
  User user;
  Claim claim;

  NewClaimPage3({User user, Claim claim, Key key}) {
    this.user = user;
    this.claim = claim;
  }

  @override
  _NewClaimPage3SFW createState() => _NewClaimPage3SFW(user, claim);
}

class _NewClaimPage3SFW extends State<NewClaimPage3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle style16B = TextStyle(
      fontFamily: 'Monserrat', fontSize: 16.0, fontWeight: FontWeight.bold);
  TextStyle style16 = TextStyle(fontFamily: 'Monserrat', fontSize: 16.0);

  User user;
  Claim claim;
  int selectedIndex = 0;
  GoogleMapController mapController;
  PermissionStatus _permissionStatus;
  LatLng _center;
  LatLng _latLng ;
  double screenHeight;
  bool permissionGranted=false;
  bool formDisplayOnly=false;
  bool showMap=false;

  final _accidentAddressController = TextEditingController();

  Set<Marker> _markers = Set();

  _NewClaimPage3SFW(User user, Claim claim) {
    this.user = user;
    this.claim = claim;
    _center = null;
    _checkPermissionStatus();
    _accidentAddressController.text=claim.accidentAddressS;
    if (claim.claimIdentifier !=null){
      formDisplayOnly=true;

    }
print('center ${_center}');
    print('claim.identifier ${claim.claimIdentifier}');
    bool result= _center==null && claim.claimIdentifier==null;
    print('result $result');
  }
  @override
  void dispose() {
    // other dispose methods
    _accidentAddressController.dispose();
    super.dispose();
  }
  void _checkPermissionStatus() async{
     await PermissionHandler().checkPermissionStatus(PermissionGroup.locationWhenInUse).then((value) {
      _permissionStatus=value;
      print('permission status is $_permissionStatus');
      setState(() {
        if (_permissionStatus==PermissionStatus.granted){
          permissionGranted=true;
          Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
              .then(_onFetchPosition);
        }
      });

    });
  }
  void requestPermission() async {
    PermissionHandler().requestPermissions(
        [PermissionGroup.locationWhenInUse]).then(_onStatusRequested);
  }

  void _onStatusRequested(
      Map<PermissionGroup, PermissionStatus> statuses) async {
    _permissionStatus = statuses[PermissionGroup.locationWhenInUse];
    print('Received status $_permissionStatus');
    if (_permissionStatus != PermissionStatus.granted) {
      PermissionHandler().openAppSettings();
    }
    if (_permissionStatus == PermissionStatus.granted) {
      Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then(_onFetchPosition);
    }
  }

  void _onFetchPosition(Position position) {
    print('current lat ${position.latitude} long ${position.longitude}');
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      showMap=true;
    });
  }

  void _updateStatus(PermissionStatus status) {
    print('Received status $status');
  }

  void _fetchAddressFromLocation(LatLng latLng) async{
    final coordinates = new Coordinates(latLng.latitude,latLng.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.addressLine} pc ${first.postalCode} ");
    setState(() {
      claim.accidentAddressS=first.addressLine;
      _accidentAddressController.text=first.addressLine;
    });
  }
  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  void onNextClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewClaimPage4(user:user,claim: claim)),
    );
  }

  void onPrevClick() {
    Navigator.pop(context);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  String validateAccidentAddress(String val) {
    return val.isEmpty ? 'Please enter the address details' : null;
  }
  void onAccidentAddressChanged(String val) async{
    claim.accidentAddressS = val;
    var addresses = await Geocoder.local.findAddressesFromQuery(val);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
    setState(() {
      if (first.coordinates !=null) {
        _center =
            LatLng(first.coordinates.latitude, first.coordinates.longitude);
      }
    });


  }


  @override
  Widget build(BuildContext context) {
    screenHeight=MediaQuery.of(context).size.height;
    print('height $screenHeight');
    return Scaffold(
// added this to close keyboard when user clicks elsewhere
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
                      RichText(
                          text: TextSpan(
                              text: 'Click the location where this accident took place',
                              style: TextStyle(color: Color(BORDERCOLOR), fontSize: 14),
                              )):SizedBox(),
                      permissionGranted == false && claim.claimIdentifier==null?
                      roundedGradientButton(
                          onPressed: requestPermission,
                          text: 'Get Current Location',
                          style: style14):SizedBox(),
                      SizedBox(
                        height: 10.0,
                      ),
                      showMap==true?
                           SizedBox(
                              height: 275,
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                myLocationEnabled: true,
                                zoomGesturesEnabled: true,
                                myLocationButtonEnabled: true,
                                rotateGesturesEnabled: true,
                                tiltGesturesEnabled: true,
                                compassEnabled: true,
                                markers: _markers,
                                initialCameraPosition: CameraPosition(
                                  target: _center,
                                  zoom: 14.0,
                                ),
                                onTap: (latLong){
                                  print("Latitude: ${latLong.latitude}, Longitude: ${latLong.longitude}");
                                  setState(() {
                                    //showMessage("Latitude: ${latLong.latitude}, Longitude: ${latLong.longitude}");
                                    _markers.clear();
                                    Marker marker=Marker(markerId: MarkerId(latLong.toString()),position: latLong,infoWindow: InfoWindow(title:'My Accident',snippet: 'Location'));
                                    _markers.add(marker);
                                    print('added marker');
                                    _fetchAddressFromLocation(latLong);
                                  });

                                  //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Latitude: ${latLong.latitude}, Longitude: ${latLong.longitude}"),));
                                },
                              ),
                            ):SizedBox(),
                      SizedBox(
                        height: 15.0,
                      ),
                      accidentAdddress(),
                      SizedBox(
                        height: 15.0,
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
                    ],
                  ),
                ),
              )
            ])),
          ),
          backgroundColor: Colors.grey,
          bottomNavigationBar:
          BottomNavBar(context,user).createBottomNavigationBar('claims'),
        );
  }

  Widget accidentAdddress( ) {
    return TextFormField(
      enabled: !formDisplayOnly,
      controller: _accidentAddressController,
      onChanged: (text) {
        onAccidentAddressChanged(text);
      },
      validator: (text) {
        return validateAccidentAddress(text);
      },
      maxLines: 3,
      style: style14,
      decoration: InputDecoration(
        labelText: 'Accident Address',
        labelStyle: style14,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(BORDERCOLOR)),
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(BORDERCOLOR)),
          borderRadius: BorderRadius.circular(16.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(BORDERCOLOR)),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
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
