import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'constants.dart';

class ListData {
  MyStatefulWidgetState _parent;
  ListData(this._parent);
  
  getListData(context, sharedPreferences, upperKey) {
    return Container(
      margin: EdgeInsets.all(30),
      color: Colors.blue,
      child: Column(children: [
        Expanded(
          child: ListView(
              padding: EdgeInsets.all(10),
              children: getWidgetList(context, sharedPreferences, upperKey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.cyan, textStyle: const TextStyle(fontSize: 20)),
          child: Text('닫기'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ]),
    );
  }

  List<Widget> getWidgetList(context, sharedPreferences, String upperkey) {
    List<Widget> buttonList = [];
    for (String key in sharedPreferences.getStringList(upperkey)!) {
      String? value = sharedPreferences.getString(key);
      if (value == null) {
        value = '';
      }
      buttonList.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.amber, textStyle: const TextStyle(fontSize: 20)),
        child: Text(value),
        onPressed: () {

          if (key.length == 2) {
            MyStatefulWidget.lDataNo = key;
            _parent.userChoiceEvent(DataType.large, sharedPreferences.getString(key));
          } else if (key.length == 4) {
            MyStatefulWidget.mDataNo = key;
            _parent.userChoiceEvent(DataType.medium, sharedPreferences.getString(key));
          } else if (key.length == 6) {
            MyStatefulWidget.sDataNo = key;
            _parent.userChoiceEvent(DataType.small, sharedPreferences.getString(key));
          }
          Navigator.of(context).pop();
        },
      ));
    }
    return buttonList;
  }
}
