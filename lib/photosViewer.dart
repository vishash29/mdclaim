import 'package:flutter/material.dart';
import 'package:mdclaim/model/imageDetails.dart';
import 'model/serviceReturn.dart';
import 'model/user.dart';
import 'common/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'common/bottomNavBar.dart';
import 'services/photoServices.dart';
import 'dart:async';
import 'model/imageDetails.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotosViewer extends StatefulWidget {
  User user;
  List<ImageDetails> imageList;

  PhotosViewer({this.user, this.imageList, Key key}) {
    print('PhotoCarousel will display ${imageList.length}');
  }

  @override
  _PhotosViewerSFW createState() => _PhotosViewerSFW(user, imageList);
}

class _PhotosViewerSFW extends State<PhotosViewer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle style16B = TextStyle(
      fontFamily: 'Monserrat', fontSize: 16.0, fontWeight: FontWeight.bold);
  TextStyle style16 = TextStyle(fontFamily: 'Monserrat', fontSize: 16.0);
  PageController _controller = PageController(viewportFraction: 0.8);
  List<ImageDetails> imageList;

  // Future<List<ImageDetails>> imageListWithImages;
  List<Image> fetchedImageList;

  User user;

  _PhotosViewerSFW(this.user, this.imageList) {}

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<List<ImageDetails>> fetchImages() async {
    //imageListWithImages=List<ImageDetails>();
    List<Image> tempList = List();
    for (int i = 0; i < 1; i++) {
      ServiceReturnModel imageReturn = await getImageFromServer(
          imageRepositoryPath: imageList[i].imageRepositoryPath,
          imageName: imageList[i].imageName);
      print('got imageRet $imageReturn');
      ImageDetails imageData = imageReturn.dynamicData;
      tempList.add(imageData.image);
      imageList[i].image = imageData.image;
      if (fetchedImageList == null) {
        fetchedImageList = List();
      }
    }
    setState(() {
      fetchedImageList = tempList;
    });
    for (int i = 1; i < imageList.length; i++) {
      ServiceReturnModel imageReturn = await getImageFromServer(
          imageRepositoryPath: imageList[i].imageRepositoryPath,
          imageName: imageList[i].imageName);
      print('got imageRet $imageReturn');
      ImageDetails imageData = imageReturn.dynamicData;
      tempList.add(imageData.image);
      imageList[i].image = imageData.image;
    }
    setState(() {
      fetchedImageList = tempList;
    });
    print('got images');
    print('got images ${fetchedImageList.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(screenTip: 'Your photos'),
      body: Center(
          child: fetchedImageList == null
              ? CircularProgressIndicator() :
          Container(

              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: imageList[index].image==null? AssetImage('assets/images/carFrontSide.png'):imageList[index].image.image,
                    initialScale: PhotoViewComputedScale.contained * 1,
                    minScale: PhotoViewComputedScale.contained * 0.4,
                    //heroAttributes: HeroAttributes(tag: galleryItems[index].id),
                  );
                },
                itemCount: imageList.length,
                loadingBuilder: (context, event) {
                  print('loading builder...');
                    return Center(
                      child: Container(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          value: event == null
                              ? 0
                              : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes,
                        ),
                      ),
                    );
                }),
                //backgroundDecoration: widget.backgroundDecoration,
                //pageController: widget.pageController,
                // onPageChanged: onPageChanged,
              )
          ),

      backgroundColor: Colors.grey,
      bottomNavigationBar:
      BottomNavBar(context, user).createBottomNavigationBar('photList'),
    );
  }
}

