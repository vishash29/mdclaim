

//Has list of unique dates when user has updated a photo
class UserPhotoDateList {

String userIdentifier;
List<String> uniqueDateList;
}

//Has list of Photos uploaded
class UserPhotoDetailList {

  String userIdentifier;
  List<PhotoModel> photoList;
}


class PhotoModel{
  String photoURL;
  String photoType;
  String uploadDateAsString;
}

