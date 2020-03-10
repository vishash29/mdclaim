import 'package:flutter/material.dart';
import 'package:mdclaim/common/widgets.dart';
import 'model/user.dart';
import 'common/bottomNavBar.dart';
import 'model/claim.dart';
import 'package:mdclaim/model/serviceReturn.dart';
import 'package:badges/badges.dart';
import 'newClaimPage1.dart';
import 'services/claimServices.dart';

class ListOfClaimsPage extends StatefulWidget {
  User user;

  ListOfClaimsPage({User user, Key key}) {
    this.user = user;
  }

  @override
  _ListOfClaimsPageSFW createState() => _ListOfClaimsPageSFW(user);
}

class _ListOfClaimsPageSFW extends State<ListOfClaimsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle style16 = TextStyle(
      fontFamily: 'Monserrat', fontSize: 16.0, fontWeight: FontWeight.bold);
  User user;
  int selectedIndex = 0;

  _ListOfClaimsPageSFW(User user) {
    this.user = user;
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  Future<ServiceReturnModel> fetchClaims() async {
    print('fetching claimsList for ${user.email}');
    var result = await getClaimsList(user.mondIdentifier);
    print('result of fetchClaims $result');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: createAppBar(screenTip: 'Your claims'),
        body: Padding(
          child: FutureBuilder<ServiceReturnModel>(
            future: fetchClaims(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? ClaimList(user: user, returnModel: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
          padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
        ),
        backgroundColor: Colors.grey,
        bottomNavigationBar:
            BottomNavBar(context, user).createBottomNavigationBar('home'),
      ),
    );
  }

  void onItemTapped(int index) {
    Navigator.pop(context);
  }
}

class ClaimList extends StatefulWidget {
  User user;
  ServiceReturnModel returnModel;

  ClaimList({User user, ServiceReturnModel returnModel,Key key}) {
    this.user = user;
    this.returnModel=returnModel;
  }

  @override
  _ClaimListPageSFW createState() => _ClaimListPageSFW(user: user,returnModel:returnModel);
}

class _ClaimListPageSFW extends State<ClaimList> {
  User user;
  List<Claim> claimList;
  ServiceReturnModel returnModel;
  BuildContext _context;

  TextStyle style10G =
      TextStyle(fontFamily: 'Monserrat', fontSize: 10.0, color: Colors.grey);
  TextStyle style14 = TextStyle(
      fontFamily: 'Monserrat', fontSize: 14.0, color: Color(0xff011977));
  TextStyle style16 =
      TextStyle(fontFamily: 'Monserrat', fontSize: 16.0, color: Colors.black);

  _ClaimListPageSFW({this.user, this.returnModel}) {
  }

  @override
  void initState() {
    super.initState();
    if (returnModel == null) {
      Claim claim = Claim();
      claim.claimInfo =
      'You have not initiated any claims using this app so far. For any past claims, please contact us directly.';
      claimList = [claim];
    } else {
      this.claimList = returnModel.dynamicData;
      print('ListOfClaims list ${claimList}');
      if (claimList == null || claimList.length == 0) {
        Claim claim = Claim();
        claim.isInfo = true;
        claim.claimInfo =
        'You have not initiated any claims using this app so far. For any past claims, please contact us directly.';
        claimList = [claim];
      }
    }
    _addNewClaimObject();
  }
  _fetchClaim(BuildContext context, String claimId) async {
    print('fetching fetchClaim for $claimId');
    ServiceReturnModel returnModel = await getClaimDetails(claimId, user.mondIdentifier);
    if (returnModel==null){
      print('could not get the claim');
      return;
    }
    Claim claim=returnModel.dynamicData;
    if (claim==null){
      print('could not get the claim');
      return;
    }
    print('result of _fetchClaim ${returnModel.isSuccess}');
    print('result of _fetchClaim ${returnModel.dynamicData}');
    print('claim type is ${claim.claimType}');
    print('claim TP is ${claim.thirdPartyInfoList}');
    if (claim.thirdPartyInfoList !=null){
      print('claim TP FN is ${claim.thirdPartyInfoList[0].firstName}');
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewClaimPage1(user: user,claim: claim,)),
    );

  }

  void _addNewClaimObject() {
    print('adding newclaim row');
    Claim claim = Claim();
    claim.isNewClaim = true;
    claimList.insert(0, claim);
    claim.claimInfo = "Click here to launch a new Claim";
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return ListView.builder(
      itemCount: claimList.length,
      itemBuilder: (context, index) {
        return Column(children: <Widget>[
          createMenu(
              context: context, claimInfo: claimList[index], index: index)
        ]);
      },
    );
  }

//createMenu(user: userList[index].firstName+' '+userList[index].lastName+' G'+userList[index].grade,subtitle:userList[index].subjectsD,image:userList[index].profileURL,index: index)
  Widget createMenu({BuildContext context, Claim claimInfo, int index}) {
    if (claimInfo.isInfo) {
      return Card(
        elevation: 6.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: new InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewClaimPage1(user: user,claim: Claim(),)),
            );
          },
          child: Container(child: createInfoMenu(claimInfo)),
        ),
      );
    }
    if (claimInfo.isNewClaim) {
      return Card(
        elevation: 6.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: new InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewClaimPage1(user: user,claim: Claim(),)),
            );
          },
          child: Container(child: createNewClaimMenu(claimInfo)),
        ),
      );
    }
    return Stack(
      children: <Widget>[
        Card(
          elevation: 6.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: new InkWell(
            onTap: () {
              _fetchClaim(context, claimInfo.claimIdentifier);
            },
            child: Container(child: createDetailsMenu(claimInfo)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _getClaimStatusBadge(
                status: claimInfo.claimStatusDescription, padding: 10),
          ],
        ),
      ],
    );
  }

  Widget createInfoMenu(Claim claimInfo) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          width: 75,
          height: 75,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/carFrontSide.png'),
          ),
        ),
        title: Text(
          claimInfo.claimInfo,
          style: style14,
        ));
  }

  Widget createNewClaimMenu(Claim claimInfo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          _context,
          MaterialPageRoute(builder: (context) => NewClaimPage1(user: user,claim: Claim(),)),
        );
      },
      child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            width: 75,
            height: 75,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/carFrontSide.png'),
            ),
          ),
          title: Text(
            claimInfo.claimInfo,
            style: style14,
          )),
    );
  }

  Widget createDetailsMenu(Claim claimInfo) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          claimInfo.claimIdentifier,
          style: style14,
        ),
        subtitle: Row(
          children: <Widget>[
            IconButton(
              icon: Image.asset("assets/images/collisionIcon.png"),
              color: Color(BORDERCOLOR),
              iconSize: 8,
            ),
            Flexible(
                child: Text(claimInfo.claimTypeDescription, style: style10G)),
            SizedBox(
              width: 20,
            ),
            IconButton(
              icon: Image.asset("assets/images/dateIcon.png"),
              color: Color(BORDERCOLOR),
              iconSize: 8,
            ),
            Flexible(child: Text(claimInfo.claimDateFmt, style: style10G)),
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0));
  }

  Widget _getClaimStatusBadge({String status, double padding}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Badge(
        position: BadgePosition.topRight(),
        badgeColor: Color(BORDERCOLOR),
        borderRadius: 20,
        padding: EdgeInsets.all(padding ?? 4),
        shape: BadgeShape.square,
        badgeContent: Text(
          status,
          style: TextStyle(
            fontFamily: 'Monserrat',
            fontSize: 12.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
