import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:flutter/cupertino.dart';

const BORDERCOLOR = 0xff011977;

Widget createButton(
    {BuildContext context,
    Function onPressed,
    String text,
    TextStyle style,
    Color btnColor}) {
  return Material(
    elevation: 5.0,
    borderRadius: BorderRadius.circular(30.0),
    color: btnColor,
    child: MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: () {
        onPressed();
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget createDropdown1(
    {String label,
    String isEmptyField,
    String valueField,
    Function onClick,
    TextStyle style,
    List<DropdownMenuItem<String>> items}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      border: Border.all(
          color: Color(BORDERCOLOR), style: BorderStyle.solid, width: 0.80),
    ),
    child: new DropdownButtonHideUnderline(
      child: new DropdownButton<String>(
          value: valueField,
          //style: style,
          isDense: true,
          onChanged: (String newValue) {
            onClick(newValue);
          },
          items: items),
    ),
  );
}

Widget createDropdown(
    {bool disabled=false,String label,
    String isEmptyField,
    String valueField,
    Function onClick,
    TextStyle style,
    List<DropdownMenuItem<String>> items}) {
  return FormField<String>(
    enabled:!disabled ,
    builder: (FormFieldState<String> state) {
      return InputDecorator(
        decoration: InputDecoration(
            labelText: label,
            labelStyle:style,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(color: Color(BORDERCOLOR))),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        isEmpty: isEmptyField == '',
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton<String>(
              value: valueField,
              //style: style,
              isDense: true,
              onChanged: (String newValue) {
                onClick(newValue);
              },
              items: items),
        ),
      );
    },
  );
}

//0xff011977
Widget roundedGradientButton(
    {bool disabled=false,Function onPressed, String text, TextStyle style,width=300.0}) {
  return Container(
    height: 75.0,
    width: width,
    child: RaisedButton(

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          constraints: BoxConstraints(minHeight: 50.0),
          alignment: Alignment.center,
          child: Container(
            height: 50.0,
            width: 275,
            child: RaisedButton(
              onPressed: () {
               disabled==true? null:onPressed();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(BORDERCOLOR), Color(0xff014A9C)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  constraints: BoxConstraints(minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void addToDropdown(LinkedHashMap<String, String> valuesToUse,
    List<DropdownMenuItem<String>> menuItemList, TextStyle style) {
  menuItemList.clear();
  for (String key in valuesToUse.keys) {
    menuItemList.add(DropdownMenuItem<String>(
      child: Text(
        valuesToUse[key],
      ),
      value: key,
    ));
    print('adding $key value ${valuesToUse[key]}');
  }
}

Widget textAreaWithoutIcon(
    { bool disabled=false,String initialValue,String labelText,
    TextStyle labelStyle,
    Function onChanged,
    Function validator,
    int maxLines}) {
  return TextFormField(
    initialValue: initialValue==null?'':initialValue,
    enabled: !disabled,
    onChanged: (text) {
      onChanged(text);
    },
    validator: (text) {
      return validator(text);
    },
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: labelStyle,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(BORDERCOLOR)),
        borderRadius: BorderRadius.circular(16.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(BORDERCOLOR)),
        borderRadius: BorderRadius.circular(16.0),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(BORDERCOLOR)),
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
  );
}

Widget textFieldWithoutIcon(
    { bool disabled=false,String labelText,
    TextStyle labelStyle,
    Function onChanged,
    Function validator}) {
  return TextFormField(
    enabled: !disabled,
    onChanged: (text) {
      onChanged(text);
    },
    validator: (text) {
      return validator(text);
    },
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: labelStyle,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(BORDERCOLOR)),
        borderRadius: BorderRadius.circular(32.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(BORDERCOLOR)),
        borderRadius: BorderRadius.circular(32.0),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(BORDERCOLOR)),
        borderRadius: BorderRadius.circular(32.0),
      ),
    ),
  );
}

Widget textFieldWithoutIcon2(
    { bool disabled=false,String initialValue,String labelText,
      TextInputType keyboardType=TextInputType.text,
      TextStyle labelStyle,
      Function onChanged,
      Function validator}) {
  return TextFormField(
    enabled: !disabled,
    onChanged: (text) {
      onChanged(text);
    },
    validator: (text) {
      return validator(text);
    },
    keyboardType: keyboardType,
    initialValue: initialValue==null?'':initialValue,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: labelStyle,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(BORDERCOLOR)),
        borderRadius: BorderRadius.circular(16.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(BORDERCOLOR)),
        borderRadius: BorderRadius.circular(16.0),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(BORDERCOLOR)),
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
  );
}
Widget textFieldWithIcon(
    {bool disabled=false,String initialValue,String labelText,String imageLink,
      TextStyle labelStyle,
      Function onChanged,
      Function validator}) {
  return TextFormField(
    enabled: !disabled,
    initialValue: initialValue==null?'':initialValue,
    onChanged: (text) {
      onChanged(text);
    },
    validator: (text) {
      return validator(text);
    },
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: labelStyle,
      prefixIcon: ImageIcon(AssetImage(imageLink),color: Color(BORDERCOLOR),),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(BORDERCOLOR)),
        borderRadius: BorderRadius.circular(32.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(BORDERCOLOR)),
        borderRadius: BorderRadius.circular(32.0),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(BORDERCOLOR)),
        borderRadius: BorderRadius.circular(32.0),
      ),
    ),
  );
}

Widget createAppBar({String screenTip}) {
  print('screenTip $screenTip');
  return AppBar(
    centerTitle: true,
    title: ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Image.asset(
            'assets/images/mondCloudLogo3.png',
            scale: 0.50,
          ),
          screenTip==null? SizedBox():Text(screenTip,style: TextStyle(fontFamily: 'Monserrat', fontSize: 12.0,color: Color(BORDERCOLOR)),),
        ],
      ),

    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
    backgroundColor: Colors.white,
  );
}