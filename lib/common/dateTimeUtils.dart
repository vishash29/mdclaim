import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';


class DateUtils{

  String getFormattedDateWithTime(DateTime dateTime) {
    var formatter = new DateFormat('LLL');
    var formatter2=new DateFormat().add_jm();
    return formatter.format(dateTime)+' '+dateTime.day.toString()+getDateSufix(dateTime.day)+ ' '+dateTime.year.toString()+ ' at ' +formatter2.format(dateTime);
    
  }

  String getFormattedDate(DateTime dateTime) {
    var formatter = new DateFormat('LLL');
    var formatter2=new DateFormat().add_jm();
    return formatter.format(dateTime)+' '+dateTime.day.toString()+getDateSufix(dateTime.day)+ ' '+dateTime.year.toString();

  }
  String getDateSufix(int day){

    if (day >=4 && day <=20){
      return 'th';
    }
    if (day== 1 || day ==21 || day==31){
      return 'st';
    }

    if (day== 2 || day==22){
      return 'nd';
    }
    if (day== 3 || day==23){
      return 'rd';
    }

    if (day >= 24 && day <=30){
      return 'th';
    }

  }
}