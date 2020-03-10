import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'common/widgets.dart';
import 'model/user.dart';
import 'model/claimsImageInfo.dart';
import 'dart:io';
import 'services/photoServices.dart';



class UploadPhotoPage extends StatefulWidget {

  User user;
  String photoType;
  String photoSubType;
  String photoTypeDesc;

  UploadPhotoPage({User user, String photoType,String photoTypeDesc,String photoSubType,Key key}) {
    this.user = user;
    this.photoType=photoType;
    this.photoSubType=photoSubType;
    this.photoTypeDesc=photoTypeDesc;

  }

  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState(user:user,photoType:photoType,photoSubType:photoSubType,photoTypeDesc:photoTypeDesc);
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File _imageFile;
  User newUser;
  String photoType;
  String photoSubType;
  String photoTypeDesc;
  ClaimsImageInfo imageInfo;
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle style = TextStyle(fontFamily: 'Monserrat', fontSize: 16.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _UploadPhotoPageState({User user,String photoType,String photoSubType,String photoTypeDesc}) {
    this.newUser = user;
    this.photoType=photoType;
    this.photoSubType=photoSubType;
    this.photoTypeDesc=photoTypeDesc;
    imageInfo=ClaimsImageInfo();
    imageInfo.imageType=photoType;
    imageInfo.imageSubType=photoSubType;
    imageInfo.userFirebaseId=user.firebaseUID;
  }

  Future<void> _selectImage(ImageSource imageSource) async {
    File selected = await ImagePicker.pickImage(source: imageSource);
    setState(() {
      _imageFile = selected;
      newUser.profileURL = selected.path;
    });
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
    );
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  void _clearImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void uploadPhoto() async {

    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(duration: new Duration(seconds: 2), content:
        new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text("  Saving...")
          ],
        ),
        ));


    uploadPhotoToServer(newUser,imageInfo,_imageFile,);
    showMessage("Updated photo ", Colors.green);
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: createAppBar(screenTip: 'Upload photos'),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () {
                  _selectImage(ImageSource.camera);
                },
              ),
              IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: () {
                  _selectImage(ImageSource.gallery);
                },
              ),
              IconButton(
                icon:Icon(Icons.arrow_back_ios),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                children: buildChildren(context))
        )

    );
  }

  List<Widget> buildChildren(BuildContext context) {
    List<Widget> builder = [];
    builder.add(SizedBox(
      height: 15.0,
    ));

     if (_imageFile == null) {
      builder.add(SizedBox(
        height: 5.0,
      ));
      builder.add(Text(photoTypeDesc));
    } else if (_imageFile != null) {
       builder.add(roundedGradientButton(onPressed:uploadPhoto,text:'Save', style:style14));

      builder.add(SizedBox(
        height: 15.0,
      ));
      builder.add(FlatButton(
        child: Icon(Icons.crop),
        onPressed: _cropImage,
      ));
      builder.add(SizedBox(
        height: 15.0,
      ));
      builder.add(
        ClipRect(
          child: Image.file(
            _imageFile,
            width: MediaQuery.of(context).size.width*0.95,
            height: MediaQuery.of(context).size.height*0.75,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    builder.add(SizedBox(
      height: 10.0,
    ));

    builder.add(SizedBox(
      height: 10.0,
    ));

    return builder;
  }
}
