import 'package:flutter/material.dart';
import 'model/user.dart';
import 'common/bottomNavBar.dart';
import 'model/imageDateInfo.dart';
import 'package:mdclaim/model/serviceReturn.dart';
import 'services/photoServices.dart';
import 'photosViewer.dart';
import 'common/widgets.dart';

class ListOfPhotosPage extends StatefulWidget {
  User user;


  ListOfPhotosPage({User user,Key key}) {
    this.user = user;
  }

  @override
  _ListOfPhotosPageSFW createState() => _ListOfPhotosPageSFW(user);
}

class _ListOfPhotosPageSFW extends State<ListOfPhotosPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 14.0);
  TextStyle style16 = TextStyle(
      fontFamily: 'Monserrat', fontSize: 16.0, fontWeight: FontWeight.bold);
  User user;
 // int selectedIndex = 0;

  _ListOfPhotosPageSFW(User user) {
    this.user = user;
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  Future<ServiceReturnModel> fetchImages() async {
    print('fetching imageDateList');
    var result = await getImageDateList(user.mondIdentifier);
    print('result of fetchImages $result');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: createAppBar(screenTip: 'Your photos'),
        body: Padding(
          child: FutureBuilder<ServiceReturnModel>(
            future: fetchImages(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? PhotoDateList(user:user, returnModel:snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
          padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
        ),
        backgroundColor: Colors.grey,
          bottomNavigationBar: BottomNavBar(context,user).createBottomNavigationBar('home'  ),
      ),
    );
  }

  void onItemTapped(int index) {
      Navigator.pop(context);
  }
}


class PhotoDateList extends StatelessWidget {
  User user;
  //this is the list of dates on which photos were taken. each has a further list of names(but not the image)
  List<ImageDateInfo> dateList;

  TextStyle style14 = TextStyle(fontFamily: 'Monserrat', fontSize: 12.0,color: Color(0xff011977));
  TextStyle style16 = TextStyle(fontFamily: 'Monserrat', fontSize: 16.0,color: Colors.black);

  PhotoDateList({this.user,ServiceReturnModel returnModel}) {
    if (returnModel!=null) {
      this.dateList = returnModel.dynamicData;
      print('ListOfPhotoDates dateList ${dateList}');
      if (dateList==null || dateList.length==0){
        ImageDateInfo imageDateInfo=ImageDateInfo();
        imageDateInfo.imageInfo='You have not uploaded any pictures so far. Upload photos of your car every month or quarter.';
        dateList=[imageDateInfo];
        imageDateInfo.imageList=[];
      }
    }
    else{
      ImageDateInfo imageDateInfo=ImageDateInfo();
      imageDateInfo.imageInfo='You have not uploaded any pictures so far. Upload photos of your car every month or quarter.';
      dateList=[imageDateInfo];
      imageDateInfo.imageList=[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dateList.length,
      itemBuilder: (context, index) {
        return Column(children: <Widget>[
          createMenu(context:context,imageDateInfo: dateList[index])
        ]);
      },
    );
  }

//createMenu(user: userList[index].firstName+' '+userList[index].lastName+' G'+userList[index].grade,subtitle:userList[index].subjectsD,image:userList[index].profileURL,index: index)
  Widget createMenu({BuildContext context,ImageDateInfo imageDateInfo}) {
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
            MaterialPageRoute(builder: (context) => PhotosViewer(user:user,imageList:imageDateInfo.imageList)),
          );

        },
        child: Container(

          child: imageDateInfo.imageList.length > 0 ?createDetailsMenu(imageDateInfo):createInfoMenu(imageDateInfo),
        ),
      ),
    );
  }



  Widget createInfoMenu(ImageDateInfo imageDateInfo){
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          width: 75,
          height: 75,
          child:    CircleAvatar(
            backgroundImage: AssetImage('assets/images/carFrontSide.png'),
          ),
        ),
        title: imageDateInfo.formattedImageDate== null? Text(imageDateInfo.imageInfo,style: style16,):Text(
          imageDateInfo.formattedImageDate,
          style: style16,
        )
    );


  }
  Widget createDetailsMenu(ImageDateInfo imageDateInfo){
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          width: 75,
          height: 75,
          child:    CircleAvatar(
            backgroundImage: AssetImage('assets/images/carFrontSide.png'),
          ),
        ),
        title: imageDateInfo.formattedImageDate== null? Text(imageDateInfo.imageInfo,style: style16,):Text(
          imageDateInfo.formattedImageDate,
          style: style16,
        ),
        subtitle: Row(
          children: <Widget>[
            Flexible(
              child: imageDateInfo.imageList.length > 1? Text('Found ${imageDateInfo.imageList.length} photos', style: style14):Text('Found ${imageDateInfo.imageList.length} photo', style: style14),
            )
          ],
        ),
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0));
  }

}

