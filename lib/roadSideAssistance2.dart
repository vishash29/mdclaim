import 'package:flutter/material.dart';
import 'model/user.dart';
import 'model/claim.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'common/widgets.dart';
import 'common/bottomNavBar.dart';
import 'appHomePage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoder/geocoder.dart';

class RoadSideAssistance2 extends StatefulWidget {
  User user;

  RoadSideAssistance2({User user, Key key}) {
    this.user = user;
  }

  @override
  _RoadSideAssistance2SFW createState() => _RoadSideAssistance2SFW(user);
}

class _RoadSideAssistance2SFW extends State<RoadSideAssistance2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle style14Color = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0,color: Color(0xff011977));
  TextStyle style16B = TextStyle(
      fontFamily: 'Monserrat', fontSize: 16.0, fontWeight: FontWeight.bold);
  TextStyle style16 = TextStyle(fontFamily: 'Monserrat', fontSize: 16.0);

  User user;
  BuildContext _buildContext;

  int selectedIndex = 0;
  GoogleMapController mapController;
  PermissionStatus _permissionStatus;
  LatLng _center;
  LatLng _latLng;

  double screenHeight;
  bool permissionGranted = false;
  final _currentLocationAddressController = TextEditingController();
  Set<Marker> _markers = Set();

  _RoadSideAssistance2SFW(User user) {
    this.user = user;
    _center = null;
    _checkPermissionStatus();
  }

  void _checkPermissionStatus() async {
    await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then((value) {
      _permissionStatus = value;
      print('permission status is $_permissionStatus');
      setState(() {
        if (_permissionStatus == PermissionStatus.granted) {
          permissionGranted = true;
          Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
              .then(_onFetchPosition);
        }
      });
    });
  }

@override
void dispose() {
  // other dispose methods
  _currentLocationAddressController.dispose();
  super.dispose();
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
    });
  }

  void _updateStatus(PermissionStatus status) {
    print('Received status $status');
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    Scaffold.of(_buildContext).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(message),
    ));
  }

  void onNextClick() {
    /*Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NewClaimPage3(user: user, claim: claim)),
    );*/
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  void _fetchAddressFromLocation(LatLng latLng) async{
    final coordinates = new Coordinates(latLng.latitude,latLng.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.addressLine} pc ${first.postalCode} ");
    setState(() {
     _currentLocationAddressController.text=first.addressLine;
    });
  }
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    print('height $screenHeight');
    return Scaffold(
      appBar: createAppBar(screenTip: 'Step 2 Confirmation'),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Builder(builder: (BuildContext context) {
          _buildContext=context;
          return Container(
              child: ListView(children: <Widget>[
             createCard(),
          ]));
        }),
      ),
      backgroundColor: Colors.grey,
      bottomNavigationBar:
      BottomNavBar(context,user).createBottomNavigationBar('roadSide'),
    );
  }

  Widget createCard(){
    return Card(
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
            permissionGranted == false
                ? roundedGradientButton(
                onPressed: requestPermission,
                text: 'Get Current Location',
                style: style14)
                : SizedBox(),
            SizedBox(
              height: 10.0,
            ),
            _center == null
                ? SizedBox()
                : SizedBox(
              height: 350,
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
                onTap: (latLong) {

                  setState(() {
                    //showMessage("Latitude: ${latLong.latitude}, Longitude: ${latLong.longitude}");
                    _markers.clear();
                    Marker marker = Marker(
                        markerId: MarkerId(latLong.toString()),
                        position: latLong,
                        infoWindow: InfoWindow(
                            title: 'Location',
                            snippet: 'My position'));
                    _markers.add(marker);
                    print('added marker');
                    _fetchAddressFromLocation(latLong);
                  });

                  //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Latitude: ${latLong.latitude}, Longitude: ${latLong.longitude}"),));
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            currentLocationAdddress(),
            SizedBox(
              height: 15.0,
            ),
            _markers.isEmpty? SizedBox(
             child: Text('Please confirm your location by clicking the map',style: style14Color,))
            :
            roundedGradientButton(
                onPressed: () {
                  showMessage(
                      'Your details have been submitted to ABC Towing Inc.They will contact you shortly');
                },
                text: 'Submit',
                style: style14),
          ],
        ),
      ),
    );
  }

  Widget currentLocationAdddress( ) {
    return TextFormField(
      controller: _currentLocationAddressController,
      onChanged: (text) {
        onLocationAddressChanged(text);
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

  void onLocationAddressChanged(String val) async{
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

}
