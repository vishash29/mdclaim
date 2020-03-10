import 'package:flutter/material.dart';
import 'model/user.dart';
import 'common/bottomNavBar.dart';
import 'package:flutter/gestures.dart';
import 'uploadPhoto.dart';
import 'listOfPhotos.dart';
import 'common/widgets.dart';

class CarPhotosHomePage extends StatefulWidget {
  User user;

  CarPhotosHomePage({User user, Key key}) {
    this.user = user;
  }

  @override
  _CarPhotosHomePageSFW createState() => _CarPhotosHomePageSFW(user);
}

class _CarPhotosHomePageSFW extends State<CarPhotosHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle style16 = TextStyle(
      fontFamily: 'Monserrat', fontSize: 16.0, fontWeight: FontWeight.bold);
  User user;
  int selectedIndex = 0;
  double scale=1.3;

  /*double width;
  double imageWidth;
  double imageGap;*/

  _CarPhotosHomePageSFW(User user) {
    this.user = user;
    print('in car photo home page');
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: createAppBar(screenTip: 'Your Car Photos'),
          body: Container(
              child: ListView(children: <Widget>[
            Card(
              color: Colors.grey[150],
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical:6.0),

              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => UploadPhotoPage(
                                  user:user,photoType:'car',
                                  photoSubType:'front',
                                  photoTypeDesc:'Click camera or photo icon below to upload your car\'s front facing photo'));
                          Navigator.push(context, route);
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Image.asset(
                            'assets/images/carFrontSide.png',
                            scale: scale,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => UploadPhotoPage(
                                  user:user,photoType:'car',
                                  photoSubType:'back',
                                  photoTypeDesc:'Click camera or photo icon below to upload your car\'s back facing photo'));
                          Navigator.push(context, route);
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Image.asset(
                            'assets/images/carBackSide.png',
                            scale: scale,
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*SizedBox(
                    height: 10.0,
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => UploadPhotoPage(
                                  user:user,photoType:'car',
                                  photoSubType:'driverside',
                                  photoTypeDesc:'Click camera or photo icon below to upload your car\'s driver side facing photo'));
                          Navigator.push(context, route);
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Image.asset(
                            'assets/images/carDriverSide.png',
                            scale: scale,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => UploadPhotoPage(
                                  user:user,
                                  photoSubType:'passengerside',photoType:'car',
                                  photoTypeDesc:'Click camera or photo icon below to upload your car\'s passenger side facing photo'));
                          Navigator.push(context, route);
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Image.asset(
                            'assets/images/carPassengerSide.png',
                            scale: scale,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      FloatingActionButton(
                        backgroundColor: Color(0xff011977),
                        heroTag: "addl",
                        child: Icon(Icons.add),
                        elevation: 0,
                        onPressed: ()  {
                          Route route = MaterialPageRoute(
                              builder: (context) => UploadPhotoPage(
                                  user: user,photoType:'car',
                                  photoSubType:'additional',
                                  photoTypeDesc:'Click camera or photo icon below to upload additional pictures of your car'));
                          Navigator.push(context, route);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      RichText(
                          text: TextSpan(
                              text: 'Add additional images',
                              style: TextStyle(
                                  fontFamily: 'Monserrat',
                                  fontSize: 14.0,
                                  color: Color(0xff011977)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Route route = MaterialPageRoute(
                                      builder: (context) => UploadPhotoPage(
                                          user:user,photoType:'car',
                                          photoSubType: 'additional',
                                          photoTypeDesc: 'Click camera or photo icon below to upload additional pictures of your car'));
                                  Navigator.push(context, route);
                                })),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 60,
                      )   ,
                      Text('hello world',style: TextStyle(color: Colors.white)),
                    ],
                  ),

                  /*SizedBox(
                    width: 60,
                  ),*/
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      FloatingActionButton(
                        heroTag: "list",
                        backgroundColor: Color(0xff011977),
                        child: Icon(Icons.storage),
                        elevation: 0,
                        onPressed: ()  {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ListOfPhotosPage(user:user)),
                          );
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      RichText(
                          text: TextSpan(
                              text: 'View previously uploaded photos',
                              style: TextStyle(
                                  fontFamily: 'Monserrat',
                                  fontSize: 14.0,
                                  color: Color(0xff011977)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ListOfPhotosPage(user:user)),
                                  );
                                })),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 60,
                      )   ,
                      Text('hello world',style: TextStyle(color: Colors.white)),
                    ],
                  ),

                ],
              ),
            )
          ])),
          backgroundColor: Colors.grey,
          bottomNavigationBar:
          BottomNavBar(context,user).createBottomNavigationBar('photo'),
  );
  }



  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      print('selected $index');
    });
  }
}
