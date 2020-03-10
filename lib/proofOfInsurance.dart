import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'model/user.dart';
import 'common/widgets.dart';
import 'common/bottomNavBar.dart';
import 'services/photoServices.dart';
import 'model/imageDetails.dart';
import 'model/serviceReturn.dart';
import 'services/claimServices.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProofOfInsurancePage extends StatefulWidget {

  User user;

  ProofOfInsurancePage({User user,Key key}) {
    //super(key:key);
    this.user = user;
  }

  @override
  _ProofOfInsurancePageState createState() => _ProofOfInsurancePageState(user);
}

class _ProofOfInsurancePageState extends State<ProofOfInsurancePage> {
  //File _imageFile;
  User user;


  TextStyle style = TextStyle(fontFamily: 'Monserrat', fontSize: 20.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Image> fetchedImageList;

  _ProofOfInsurancePageState(User user) {
    this.user = user;
    //USE THIS for POI From Firestore
    //fetchImage();

    //size =  267576
    _fetchImageMond();
  }

  void _fetchImageMond() async {
    print('getting mondPOI');
    ServiceReturnModel returnModel = await getDocument(
        documentOwnerId: user.mondIdentifier, documentType: 'ProofOfInsurance');
    if (returnModel !=null && returnModel.dynamicData !=null) {
      setState(() {
        fetchedImageList=List();
        fetchedImageList.add(returnModel.dynamicData);
        print('set image');
      });
    }
  }

  /*
  void _fetchImageMondOld(imageRepositoryPath, String imageName) async {
print('going to getImageFromServer');
    await getImageFromServer(imageRepositoryPath, imageName).then((returnModel) {
  print('fetched image');
  print('returnModel $returnModel');
  if (returnModel !=null && returnModel.dynamicData !=null) {
  ImageDetails imageDate = returnModel.dynamicData;
  setState(() {
  _image=imageDate.image;
  print('set image');
  });

  }
  });

}*/
  void fetchImage () async{
    FirebaseStorage storage = new FirebaseStorage(
        storageBucket: 'gs://mdclaim-3e5a8.appspot.com'
    );
    print('using bucket ${storage.storageBucket}');
    String imageURL="https://firebasestorage.googleapis.com/v0/b/mdclaim-3e5a8.appspot.com/o/storage%2Fpoi%2F0%2FSU2001%2FABC100%2FproofOfInsurance.jpg?alt=media&token=d83bf873-5c06-4b9f-b60e-d6febe52ecb0";
    imageURL="https://firebasestorage.googleapis.com/v0/b/mdclaim-3e5a8.appspot.com/o/storage%2Fpoi%2F0%2FSU2001%2FABC100%2FproofOfInsurance.jpg?alt=media";
    imageURL="https://firebasestorage.googleapis.com/v0/b/mdclaim-3e5a8.appspot.com/o/storage%2Fpoi%2F0%2FSU2001%2FABC100%2FproofOfInsurance.jpg?alt=media&token=d83bf873-5c06-4b9f-b60e-d6febe52ecb0";
    imageURL="https://firebasestorage.googleapis.com/v0/b/mdclaim-3e5a8.appspot.com/o/poi%2FSU2001%2FABC100%2FproofOfInsurance.jpg?alt=media&token=59011496-44c6-4a8e-97b7-60d43e58cff5";
    //imageURL="https://storage.googleapis.com/download/storage/v1/b/mdclaim-3e5a8.appspot.com/o/poi%2FSU4311%2FDEF1003113%2FproofOfInsurance.jpg?generation=1582660432113734&alt=media";
    //mageURL="https://firebasestorage.googleapis.com/v0/b/mdclaim-3e5a8.appspot.com/o/storage/poi/SU2001/ABC100/proofOfInsurance.jpg?alt=media&token=d83bf873-5c06-4b9f-b60e-d6febe52ecb0";
    //imageURL="https://firebasestorage.googleapis.com/v0/b/mdclaim-3e5a8.appspot.com/o/poi%2FSU4311%2FDEF1003113%2FproofOfInsurance.jpg?alt=media&token=10dd4b98-f18d-4eb7-a1ed-e11478b06357";
   // imageURL="https://storage.googleapis.com/download/storage/v1/b/mdclaim-3e5a8.appspot.com/o/poi%2FSU4311%2FDEF1003113%2FproofOfInsurance.jpg?generation=1582660432113734&alt=media";
  //  imageURL="https://storage.googleapis.com/download/storage/v1/b/mdclaim-3e5a8.appspot.com/o/poi%2FSU4311%2FGYODEF1003113%2FInsurance_Contract_20200128_v1.jpg?generation=1582661854753749&alt=media";
   // imageURL="https://firebasestorage.googleapis.com/v0/b/mdclaim-3e5a8.appspot.com/o/poi%2FSU4311%2FGYODEF1003113%2FInsurance_Contract_20200128_v1.jpg?alt=media&token=c9f202ac-79c4-43bb-96b7-8d2fabcb4e09";
    print('imageURL $imageURL');
    /*storage.ref().getMetadata().then((value) {
      print('got metadata ${value.bucket}');
    });
    StorageReference imageLink = storage.ref().child('ABC100').child('proofOfInsurance.jpg');
    imageLink.getDownloadURL().then((value) {
      imageURL = value;
      print(imageURL);

    });*/

  }
  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }



  @override
  Widget buildO(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: createAppBar(screenTip: 'Proof of Insurance'),
        bottomNavigationBar:
        BottomNavBar(context,user).createBottomNavigationBar('poi'),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  //THIS WORKS, UNCOMMENT IT.
                  //imageURL==null? SizedBox(height: 15):Image.network(imageURL)
                  //_image==null? SizedBox(height: 15):_image
                ])
        )
    );
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
                    imageProvider: fetchedImageList[index].image==null? AssetImage('assets/images/carFrontSide.png'):fetchedImageList[index].image,
                    initialScale: PhotoViewComputedScale.contained * 1,
                    minScale: PhotoViewComputedScale.contained * 0.4,
                    //heroAttributes: HeroAttributes(tag: galleryItems[index].id),
                  );
                },
                itemCount: fetchedImageList.length,
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
