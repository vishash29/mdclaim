import 'package:flutter/material.dart';
import 'model/user.dart';
import 'listOfClaims.dart';
import 'common/bottomNavBar.dart';
import 'common/widgets.dart';
import 'carPhotosHomePage.dart';
import 'roadSideAssistance1.dart';
import 'proofOfInsurance.dart';
import 'policyPDFViewer.dart';


class ClaimsHomePage extends StatefulWidget {
  User user;

  ClaimsHomePage({User user, Key key}) {
    this.user = user;
  }

  @override
  _ClaimsHomePageSFW createState() => _ClaimsHomePageSFW(user);
}

class _ClaimsHomePageSFW extends State<ClaimsHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle style16 = TextStyle(fontFamily: 'Monserrat', fontSize: 16.0,fontWeight: FontWeight.bold);
  User user;
  int selectedIndex = 0;

  _ClaimsHomePageSFW(User user) {
    this.user = user;
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: createAppBar(screenTip: 'Welcome ${user.firstName}'),
        body: Container(
            child: ListView(
          children: <Widget>[
           createMenu(title: 'Roadside Assistance',subtitle: 'Ask for help ',image: 'assets/images/roadsideassistance2.png',index: 0),
           createMenu(title: 'Policy',subtitle: 'View your policy details',image: 'assets/images/policyHomePage.png',index: 1),
           createMenu(title: 'Proof of Insurance',subtitle: 'View your insurance details',image: 'assets/images/proofOfInsurance.png',index: 2),
           createMenu(title: 'Photos of My Car',subtitle: 'Upload and save photos',image: 'assets/images/photosOfMyCar.png',index: 3),
           createMenu(title: 'Claims..',subtitle: 'View, launch a new claim',image: 'assets/images/roadsideassistance.png',index: 4),

          ],
        )),
        backgroundColor: Colors.grey,
        bottomNavigationBar: BottomNavBar(context,user).createBottomNavigationBar('home'  ),
      ),
    );
  }

  /*void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      print('selected $index');
    });
  }*/




  Widget createMenu({String title,String subtitle,String image,int index}) {
    return Card(
      elevation: 6.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: new InkWell(
        onTap: () {
          print("tapped $index");
          if (index==0){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RoadSideAssistance1(user:user)),
            );
            return;
          }
          if (index==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PolicyPDFViewerPage(user:user)),
            );
            return;
          }
          if (index==2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProofOfInsurancePage(user:user)),
            );
            return;
          }
          if (index==3){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CarPhotosHomePage(user:user)),
            );
            return;
          }
          if (index==4){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListOfClaimsPage(user:user)),
            );
            return;
          }

        },
        child: Container(
          child: createMenuDetails(title, subtitle, image),
        ),
      ),
    );
  }


  Widget createMenuDetails(String title,String subtitle,String image){
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
       leading: Container(
         decoration: new BoxDecoration(
            // color: Colors.green,
             borderRadius: new BorderRadius.only(
               topLeft: const Radius.circular(40.0),
               topRight: const Radius.circular(40.0),
             )
         ),
         child: Image.asset(image,),
       ),
        title: Text(
      title,
      style: style16,
    ),
        subtitle: Row(
          children: <Widget>[
            Flexible(
              child: Text(subtitle, style: style14),
            )
          ],
        ),
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0));
  }


}
