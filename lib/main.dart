import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

void main() => runApp(ClaimsMainPage());


class ClaimsMainPage extends StatefulWidget {
  @override
  _ClaimsMainPageState createState() => _ClaimsMainPageState();
}

/*class MondClaims extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'mondCloud Claims',
        theme: ThemeData(brightness: Brightness.light),
        home: Scaffold(body: HomePage()));
  }
}*/

class _ClaimsMainPageState extends State<ClaimsMainPage>  with SingleTickerProviderStateMixin{

  TextStyle style = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0,);
  TextStyle selectedTab = new TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle unselectedTab = new TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync:this,length:2);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return new MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'mondCloud Claims',
          theme: ThemeData(brightness: Brightness.light),
          home: Scaffold(body: createListView()));
  }

  Widget createListView(){

    return ListView(children: [
      Container(
          color: Colors.white24,
         // height: 150.0,
          child: Center(
            child: Image.asset(
              'assets/images/mondCloudLogo5.png',
              scale: 0.50,
            ),
          )),
      DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                  labelStyle:selectedTab,
                  labelColor: Color(0xff011977),
                  indicatorColor: Color(0xff011977),
                  unselectedLabelStyle: unselectedTab,
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  onTap:(int index){
                print('clicked $index');

                  },tabs: [Tab(text: 'LOGIN'), Tab(text: 'SIGN UP')]),
              Container(
                  height: 1800.0,
                  child: TabBarView(
                    children: [
                      Center(child: MyClaimsLoginPage(tabController: _tabController,)),
                      Center(child:ClaimsRegisterPage()),
                    ],
                    controller: _tabController,
                  ))
            ],
          ))
    ]);
  }
}
