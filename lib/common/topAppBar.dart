import 'package:flutter/material.dart';
import 'widgets.dart';

class TopAppBar {
  Widget createAppBar({String screenTip}) {
    print('screenTip $screenTip');
    return AppBar(
      centerTitle: true,
      title: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.asset(
              'assets/images/mondCloudLogo3.png',
              scale: 0.50,
            ),
            screenTip==null? SizedBox():Text(screenTip,style: TextStyle(fontFamily: 'Monserrat', fontSize: 12.0,color: Color(BORDERCOLOR)),),
          ],
        ),

      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
