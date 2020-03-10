import 'package:flutter/material.dart';
import 'widgets.dart';
import '../appHomePage.dart';
import '../model/user.dart';
import '../main.dart';
import '../userProfile.dart';

class BottomNavBar {
  BuildContext context;
  User user;
  int _selectedIndex = 0;

  BottomNavBar(this.context, this.user);

  Widget createBottomNavigationBar(String currentPage) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(_getHomeIcon(currentPage)),
                color: Color(BORDERCOLOR)),
            title: Text('b')),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(_getSupportIcon(currentPage)),
              color: Color(BORDERCOLOR),
            ),
            title: Text('c')),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(_getProfileIcon(currentPage)),
              color: Color(BORDERCOLOR),
            ),
            title: Text('d')),
        BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back_ios, color: Color(0xff011977)),
            title: Text('e')),
        BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app, color: Color(0xff011977)),
            title: Text('f')),
      ],
      currentIndex: _selectedIndex,
      fixedColor: Colors.deepPurple,
      onTap: (index) {
        onItemTapped(index);
      },
    );
  }

  String _getHomeIcon(String currentPage) {
    if (currentPage.compareTo('home') == 0) {
      return 'assets/images/homeInactive.png';
    }
    return 'assets/images/homeActive.png';
  }

  String _getClaimsIcon(String currentPage) {
    print('claims icon $currentPage');
    if (currentPage.compareTo('claims') == 0) {
      print('using inactive');
      return 'assets/images/claimsInactive.png';
    }
    print('using active');
    return 'assets/images/claimsActive.png';
  }

  String _getSupportIcon(String currentPage) {
    if (currentPage.compareTo('support') == 0) {
      return 'assets/images/supportInactive.png';
    }
    return 'assets/images/supportActive.png';
  }

  String _getProfileIcon(String currentPage) {
    if (currentPage.compareTo('profile') == 0) {
      return 'assets/images/profileInactive.png';
    }
    return 'assets/images/profileActive.png';
  }

  onItemTapped(int index) {
    print('bottom nav user tapped $index');
    _selectedIndex = index;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ClaimsHomePage(user: user)),
      );
    }
    else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserProfilePage(user: user)),
      );
    }
    else if (index == 3) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
    else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ClaimsMainPage()),
      );
    }

  }
}
