import 'package:biding/init_data/open_api.dart';
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

  List<Widget> getWidgetList(
      context, sharedPreferences, String upperkey)  {
    List<Widget> buttonList = [];
    if (upperkey.length < 4) {
      for (String key in sharedPreferences.getStringList(upperkey)!) {
        String? value = sharedPreferences.getString(key);
        if (value == null) {
          value = '데이터없음';
        }
        buttonList.add(getButton(context, key, value.trim()));
      }
    } else {
      var sdata = ManageOpenApi().getSDataHttp(upperkey);
      for (Map map in sdata) {
        String key = 'stdSpciesNewCode';
        String value = map['stdSpciesNewCode'];
        if (value == null) {
          value = '데이터없음';
        }
        buttonList.add(getButton(context, key, value.trim()));
      }
    }
    return buttonList;
  }

  ButtonStyleButton getButton(context, key, value) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.amber, textStyle: const TextStyle(fontSize: 20)),
      child: Text(value),
      onPressed: () {
        if (key.length == 2) {
          MyStatefulWidget.lDataNo = key;
          _parent.userChoiceEvent(DataType.large, value);
        } else if (key.length == 4) {
          MyStatefulWidget.mDataNo = key;
          _parent.userChoiceEvent(DataType.medium, value);
        } else if (key.length == 6) {
          MyStatefulWidget.sDataNo = key;
          _parent.userChoiceEvent(DataType.small, value);
        }
        Navigator.of(context).pop();
      },
    );
  }
}
