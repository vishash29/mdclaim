import 'package:flutter/material.dart';
import 'model/user.dart';
import 'model/serviceReturn.dart';
import 'dart:io';
import 'common/widgets.dart';
import 'common/bottomNavBar.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'services/claimServices.dart';

class PolicyPDFViewerPage extends StatefulWidget {
  User user;

  PolicyPDFViewerPage({User user, Key key}) {
    //super(key:key);
    this.user = user;
  }

  @override
  _PolicyPDFViewerPageState createState() => _PolicyPDFViewerPageState(user);
}

class _PolicyPDFViewerPageState extends State<PolicyPDFViewerPage> {
  File _imageFile;
  User user;
  int selectedIndex = 0;
  String imageURL = null;
  PDFDocument document;
  bool _isLoading = true;

  TextStyle style = TextStyle(fontFamily: 'Monserrat', fontSize: 20.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _PolicyPDFViewerPageState(User user) {
    this.user = user;
    fetchPDFAsync();
  }

  void fetchPDFAsync() async {
    print('getting mondPDF');
    ServiceReturnModel returnModel = await getDocument(
        documentOwnerId: user.mondIdentifier, documentType: 'PolicyDocument');
    File f1 = returnModel.dynamicData;
    print('PDF file $f1');
    if (f1 == null) {
      print('cannot load PDF as file is null');
      return;
    }
    document = await PDFDocument.fromFile(f1);
    //document = await PDFDocument.fromURL(pdfURL);
    setState(() => _isLoading = false);
  }

  void fetchPDFAsyncFB() async {
    //document = await PDFDocument.fromAsset('assets/images/policy_P100.pdf');
    String pdfURL =
        "https://firebasestorage.googleapis.com/v0/b/mdclaim-3e5a8.appspot.com/o/policyPDF%2FSPECIMEN-StLucia-Motor.pdf?alt=media&token=ad576861-de84-4755-b88d-be327893eeba";

    document = await PDFDocument.fromURL(pdfURL);
    setState(() => _isLoading = false);
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  /* void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: createAppBar(screenTip: 'Your Policy PDF'),
      bottomNavigationBar:
          BottomNavBar(context, user).createBottomNavigationBar('policyPDF'),
      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: document)),
    );
  }
}
