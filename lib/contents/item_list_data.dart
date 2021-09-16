import 'package:biding/init_data/open_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'constants.dart';

class ListData {
  MyStatefulWidgetState _parent;

  ListData(this._parent);

  getListData(context, String what, {sharedPreferences, String? condition}) {
    return Container(
      margin: EdgeInsets.all(30),
      color: Colors.blue,
      child: Column(children: [
        Expanded(
            child: FutureBuilder(
          future: getWidgetList(context, what,
              sharedPreferences: sharedPreferences, condition: condition),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  padding: EdgeInsets.all(10), children: snapshot.data ?? []);
            } else if (snapshot.hasError) {
              print('Error:${snapshot.error}');
              return ListView(padding: EdgeInsets.all(10), children: []);
            }
            //waiting
            else {
              return ListView(padding: EdgeInsets.all(10), children: [
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ]);
            }
          },
        )),
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

  Future<List<dynamic>> getWidgetList(context, String what,
      {sharedPreferences, String? condition}) async {
    List<Widget> buttonList = [];
    if (what == 'lData') {
      for (String key in sharedPreferences.getStringList(condition)!) {
        String? value = sharedPreferences.getString(key);
        if (value == null) {
          value = '데이터없음';
        }
        buttonList.add(getButton(context, DataType.large, key, value.trim()));
      }
    } else if (what == 'mData') {
      for (String key in sharedPreferences.getStringList(condition)!) {
        String? value = sharedPreferences.getString(key);
        if (value == null) {
          value = '데이터없음';
        }
        buttonList.add(getButton(context, DataType.medium, key, value.trim()));
      }
    } else if (what == 'sData') {
      var data = await ManageOpenApi().getSpciesInfo(condition);
      for (Map map in data) {
        String key = map['stdSpciesCode'];
        String value = map['stdSpciesCodeNm'];
        buttonList.add(getButton(context, DataType.small, key, value.trim()));
      }
    } else if (what == 'wltInfo') {
      var data = await ManageOpenApi().getWltInfo();
      for (Map map in data) {
        print(map['marketco']);
        String key = map['marketco'].toString();
        String value = map['marketnm'].toString();
        buttonList.add(getButton(context, DataType.wlt, key, value.trim()));
      }
    } else if (what == 'wltprInfo') {
      var data = await ManageOpenApi().getWltprInfo(condition);
      for (Map map in data) {
        String key = map['cocode'].toString();
        String value = map['coname'].toString();
        buttonList.add(getButton(context, DataType.wltpr, key, value.trim()));
      }
    } else if (what == 'search') {
      var data = await ManageOpenApi().getWltprInfo(condition);
      for (Map map in data) {
        String key = map['cocode'].toString();
        String value = map['coname'].toString();
        buttonList.add(getButton(context, DataType.wltpr, key, value.trim()));
      }
    }
    print(buttonList);
    return buttonList;
  }

  ElevatedButton getButton(context, dataType, key, value) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.amber, textStyle: const TextStyle(fontSize: 20)),
      child: Text(value),
      onPressed: () {
        _parent.userChoiceEvent(dataType, key, value);
        Navigator.of(context).pop();
      },
    );
  }
}
