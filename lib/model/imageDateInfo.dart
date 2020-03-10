import 'package:mdclaim/model/imageDetails.dart';

import '../common/dateTimeUtils.dart';
import 'dart:math';


class ImageDateInfo{
  DateTime imageDate;
  String imageInfo;
  List<ImageDetails> imageList;



  String get formattedImageDate{
    DateUtils dateUtils=DateUtils();
    if (imageDate==null)
      return null;
    return dateUtils.getFormattedDate(imageDate);
  }

}