import 'dart:convert';
import '../common/dateTimeUtils.dart';
import 'package:flutter/widgets.dart';
import 'dart:typed_data';

class ImageDetails{
  String imageDateFt;
  DateTime imageDate;
  String imageName;
  String imageType;
  String imageSubType;
  String imageRepositoryPath;
  Image image;

   imageFromBase64String(String base64String) {
     if (base64String==null) {
       print('base64 data is null');
     }
     else{
       print('decoding string of length ${base64String.length}');
       //Uint8List bytes =  Base64Decoder().convert(base64String);
       //image=Image.memory(bytes);

       image=Image.memory(base64Decode(base64String));
       print('decoded image !!');
     }
  }

  String get formattedImageDate{
    DateUtils dateUtils=DateUtils();
    if (imageDate==null)
      return null;
    return dateUtils.getFormattedDate(imageDate);
  }


}