


class ServiceReturnModel{
  String message;
  String primaryKey;
  bool isSuccess;
  Object dynamicData;
  //When we fetch object (say User) we want to return userDetails if successful, error message if not successful
  //We use this to pass different kinds of data, For now it will return the userModel in certain cases.
  //In future it can be used to return other types of data,

  ServiceReturnModel(){
    dynamicData=null;
    isSuccess=false;
  }
  factory ServiceReturnModel.fromJson(Map<dynamic, dynamic> json) {
    print('json $json');
    bool succF= json['successFl'];

    return ServiceReturnModel()
        ..message=json['message'] as String
        ..isSuccess=json['successFl'] as bool;
  }

  bool hasData(){
    return dynamicData==null ? false:true;
  }
}