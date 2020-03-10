import 'dart:convert';
import 'networkUtils.dart';
import '../model/user.dart';
import '../model/serviceReturn.dart';
import '../model/imageDetails.dart';
import '../model/imageDateInfo.dart';
import '../model/claimsImageInfo.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<ServiceReturnModel> uploadPhotoToServer(
    User user, ClaimsImageInfo imageInfo, File imageFile) async {
  List<int> imageBytes = await imageFile.readAsBytesSync();
  Base64Encoder base64encoder = Base64Encoder();
  String base64Image = base64encoder.convert(imageBytes);
  // print('image $base64Image');
  print('will upload $imageFile');
  final imageUploadURL =
      "https://dev.mond-cloud.com/AcmeInsuranceClaims/saveImage";
  NetworkUtil _netUtil = new NetworkUtil();
  var mondImage = {};
  mondImage['imageOwnerId'] = user.mondIdentifier;
  mondImage['imageUploadDate'] = DateTime.now().toIso8601String();
  mondImage['imageName'] = path.basename(imageFile.path);
  String imageName = mondImage['imageName'];
  print('image name ${imageName}');
  mondImage['imageType'] = imageInfo.imageType;
  mondImage['imageSubType'] = imageInfo.imageSubType;
  mondImage['imageDescription'] = 'New car photo';
  mondImage['imageData'] = base64Image;

  var body = json.encode(mondImage);
  print('will invoke mond Service $imageUploadURL');
  Map<String, String> headers = Map<String, String>();
  headers['Content-Type'] = 'application/json';
print('psting $body');
  //this works
  dynamic response = await http.post(imageUploadURL,
      headers: {"Content-Type": "application/json"}, body: body);
  print('response from mond $response');
  print("response is ${response.body}");
  print('going to decode3');
  dynamic returnObject= jsonDecode(response.body);
  print('returnObject from mond $returnObject');
  ServiceReturnModel returnModel = ServiceReturnModel();
  returnModel.isSuccess = true;
  returnModel.message = "Data uploaded";
  return returnModel;
 // return uploadImageToFirebase(imageInfo, imageFile);
  //return ServiceReturnModel.fromJson(response);

  //this does not work
  /*return _netUtil.post(imageUploadURL, body:body
    ).then((dynamic res) {
      print('result from mond $res');
      return ServiceReturnModel.fromJson(res);
    });*/
}

Future<ServiceReturnModel> uploadImageToFirebase(
    ClaimsImageInfo imageInfo, File _imageFile) async {
  print('uploading to firebase...');
  StorageReference storageReference =
      FirebaseStorage.instance.ref().child(_imageFile.path);
  StorageUploadTask uploadTask = storageReference.putFile(_imageFile);
  StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

  print('uploaded $_imageFile');
  storageReference.getDownloadURL().then((downLoadURL) {
    print("URL to use nexttime is $downLoadURL");
    imageInfo.imageURL = downLoadURL;
    return _saveImageInfo(imageInfo);
  });
  ServiceReturnModel returnModel = ServiceReturnModel();
  returnModel.isSuccess = false;
  returnModel.message = "Data could not be uploaded";
  return returnModel;
}

Future<ServiceReturnModel> _saveImageInfo(
  ClaimsImageInfo imageInfo,
) async {
  final fireStoreReference = Firestore.instance;
  Map<String, dynamic> dbJson = imageInfo.toMessageJson();
  DocumentReference result3 =
      await fireStoreReference.collection(('imageDetails')).add(dbJson);
  print('after adding photo got back ${result3.documentID}');
  ServiceReturnModel returnModel = ServiceReturnModel();
  returnModel.isSuccess = true;
  returnModel.message = "Data uploaded";
  return returnModel;
}
/*var response = await http.get(mondURi, headers: {
    "Authorization": Constants.APPOINTMENT_TEST_AUTHORIZATION_KEY,
    HttpHeaders.contentTypeHeader: "application/json",
    "callMethod" : "DOCTOR_AVAILABILITY"
  });
  */

Future<ServiceReturnModel> getImageDateList(String userId) async {
  Map<String, String> qParams = {'imageOwnerId': userId};

  Uri mondUri = Uri.https(
      "dev.mond-cloud.com", "/AcmeInsuranceClaims/getImageDateList", qParams);
  ServiceReturnModel returnModel = ServiceReturnModel();
  List<ImageDateInfo> dateList = List<ImageDateInfo>();
  print('going to get from $mondUri');
  dynamic value = await http.get(mondUri);
  print("response is ${value.body}");
  print('getImageDateList from mond $value');
  print('going to decode2');
  List<dynamic> list1 = jsonDecode(value.body);
  print("Result $list1");
  //List<dynamic> list1=List<dynamic>.from(value.body.);

  list1.forEach((value) {
    print('value');
    print('$value');
    ImageDateInfo imageDate = ImageDateInfo();
    DateTime uploadDt = DateTime.fromMillisecondsSinceEpoch( value['date']);
    imageDate.imageDate = uploadDt;
    print('imageDate ${imageDate.imageDate}');

    dateList.add(imageDate);
    List<dynamic> subList = List<dynamic>.from(value['listOfImages']);
    if (subList ==null) {
      imageDate.imageList=[];
    }
    else{
      List<ImageDetails> imageDetailsList=List<ImageDetails>();
      imageDate.imageList=imageDetailsList;
      subList.forEach((element) {
        ImageDetails imageDetails=ImageDetails();
        imageDetails.imageName=element['imageName'];
        imageDetails.imageType=element['imageType'];
        imageDetails.imageSubType=element['imageSubType'];
        imageDetails.imageRepositoryPath=element['imageRepositoryPath'];
        if (imageDetails.imageName !=null && imageDetails.imageRepositoryPath !=null){
          imageDate.imageList.add(imageDetails);
          print('image name ${imageDetails.imageName} path ${imageDetails.imageRepositoryPath} added');
        }
        else{
          print('image name and path are null, not adding');
        }
      });
    }
  });
  returnModel.isSuccess = true;
  print('returning size of datelist ${dateList.length}');
  returnModel.dynamicData = dateList;
  return returnModel;
}

Future<ServiceReturnModel> getImageFromServerV1(
    String imageRepositoryPath, String imageName) async {
  ServiceReturnModel returnModel = ServiceReturnModel();
  if (imageRepositoryPath == null && imageName == null) return returnModel;
  print(
      'getting image name based on imageRepositoryPath $imageRepositoryPath  and imageName $imageName');
  Map<String, String> qParams = {
    'imageRepositoryPath': imageRepositoryPath,
    'imageName': imageName
  };
  Uri mondUri = Uri.https(
      "dev.mond-cloud.com", "/AcmeInsuranceClaims2/getImageListForOwnerAndDate", qParams);
  //TODO, REMOVE AWAIT HERE
  await http.get(mondUri).then((value) {
    print('result from getImageFromServer $value');
    print("response is ${value.body}");
    print('going to decode3');
    dynamic returnObject= jsonDecode(value.body);
    ImageDetails imageDate = ImageDetails();
    int imageUploadDate = returnObject['imageUploadDate'];
    print('imageDate $imageUploadDate');
    DateTime uploadDt = DateTime.fromMillisecondsSinceEpoch(imageUploadDate);
    imageDate.imageDate = uploadDt;
    imageDate.imageName = returnObject['imageName'];
    imageDate.imageFromBase64String(returnObject['imageData']);
    print('created image for  ${imageDate.imageName}');
    returnModel.dynamicData = returnObject;
    if (imageDate.image==null)
      print('image not found');
    else
      print('image ht ${imageDate.image.height}');
    print('returning $returnModel');
    return returnModel;

  }

  );
}
Future<List<ImageDetails>> fetchImagesFromServer(List<ImageDetails> imageList) async{
  int i=0;
  imageList.forEach((element) async {
    print('fetchImagesFromServer, processing path  ${element.imageRepositoryPath} name ${element.imageName}');
     var result=await getImageFromServer(imageRepositoryPath:element.imageRepositoryPath,imageName:element.imageName);
     ImageDetails imageDetails=result.dynamicData;
     element.image=imageDetails.image;
     i++;
    print('!!! got $i image');
    if (i==imageList.length){
      print('fetchImagesFromServer returning imageList');
      return imageList;
    }
  }
  );
  print('*******got all images');
  return imageList;
}
Future<ServiceReturnModel> getImageFromServerDel(
    String imageRepositoryPath, String imageName) async {
  ServiceReturnModel returnModel = ServiceReturnModel();
  if (imageRepositoryPath == null && imageName == null) return returnModel;
  print(
      'getting image name based on imageRepositoryPath $imageRepositoryPath  and imageName $imageName');
  Map<String, String> qParams = {
    'imageRepositoryPath': imageRepositoryPath,
    'imageName': imageName
  };
  Uri mondUri = Uri.https(
      "dev.mond-cloud.com", "/AcmeInsuranceClaims2/getImageListForOwnerAndDate", qParams);
  var value = await http.get(mondUri);
    print('result from getImageFromServer $value');
    print("response is ${value.body}");
    print('going to decode3');
    dynamic returnObject= jsonDecode(value.body);


  print('returnObject $returnObject');
  ImageDetails imageDate = ImageDetails();
    int imageUploadDate = returnObject['imageUploadDate'];


    print('imageDate $imageUploadDate');
    DateTime uploadDt = DateTime.fromMillisecondsSinceEpoch(imageUploadDate);
    imageDate.imageDate = uploadDt;
    imageDate.imageName = returnObject['imageName'];
    imageDate.imageFromBase64String(returnObject['imageData']);
    print('created image for  ${imageDate.imageName}');
    returnModel.dynamicData = imageDate;
    if (imageDate.image==null)
      print('image not found');
    else
      print('image ht ${imageDate.image.height}');
    print('returning $returnModel');
    return returnModel;

}

Future<ServiceReturnModel> getImageFromServer({String imageRepositoryPath, String imageName}) async {
  Map<String, String> qParams = {'imageRepositoryPath': imageRepositoryPath,'imageName':imageName};
  DateTime dt0=DateTime.now();
  print('invoking at  $dt0');
  Uri mondUri = Uri.https(
      "dev.mond-cloud.com", "/AcmeInsuranceClaims/getImage", qParams);
  ServiceReturnModel returnModel = ServiceReturnModel();
  print('invoking $mondUri');
  var value = await http.get(mondUri);
  DateTime dt=DateTime.now();
  print('got result at  $dt');
  //print('result from getDocument $value');
  //print("response is ${value.body}");
  print('going to decode3');
  dynamic returnObject= jsonDecode(value.body);
  print('returnObject $returnObject');
  dynamic document= returnObject['imageData'];
  ImageDetails imageData = ImageDetails();
  String base64Data=returnObject['imageData'] ;
  print('imageData $base64Data');
  imageData.imageFromBase64String(base64Data);
  DateTime dt1=DateTime.now();
  print('got result at  $dt1');
    returnModel.dynamicData = imageData;
    returnModel.isSuccess = true;
    return returnModel;
}
  /* final imageListURL = "https://dev.mond-cloud.com/AcmeInsuranceClaims2/getImageListForOwnerAndDate";

print('qParams $qParams');
  NetworkUtil _netUtil = new NetworkUtil();
  return _netUtil.get(imageListURL, qParams).then((dynamic res) {
    print('result from getImageFromServer $res');
    List<dynamic> list1=List<dynamic>.from(res);
    List<ImageDate> imageList=List<ImageDate>();
    list1.forEach((value){
      ImageDate imageDate=ImageDate();
      int imageUploadDate=value['imageUploadDate'];
      print('imageDate $imageUploadDate');
      DateTime uploadDt=DateTime.fromMillisecondsSinceEpoch(imageUploadDate);
      imageDate.imageDate=uploadDt;
      imageDate.imageName=value['imageName'];
      imageDate.imageFromBase64String(value['imageData']);
      print('created image for  ${imageDate.imageName}');
    });
    returnModel.dynamicData=imageList;
    print('size of images ${imageList.length}');
    return returnModel;
  });*/

