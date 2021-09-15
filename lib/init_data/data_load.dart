import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataLoad {
  load(AsyncSnapshot asyncSnapshot) async {
    final prefs = await SharedPreferences.getInstance();
    // snapshot은 Future 클래스가 포장하고 있는 객체를 data 속성으로 전달
    // Future<String>이기 때문에 data는 String이 된다.
    if (asyncSnapshot.hasData) {
      final contents = asyncSnapshot.data;
      for (var content in contents) {
        final rows = content.split('\n');

        List<String> groupLDataKey = [];
        for (var row in rows) {
          if (row.split(":").length != 2) {
            continue;
          }
          var key = row.split(":")[0];
          var value = row.split(":")[1];

          prefs.setString(key, value);
          print('key[$key] value[$value]');

          List<String> groupMDataKey = [];
          for (var savedKey in prefs.getKeys().toList()) {
            if (key.length + 2 == savedKey.length && savedKey.startsWith(key)) {
              groupMDataKey.add(savedKey);
            }
          }
          if (groupMDataKey.length > 0) {
            var groupKey = key + '_';
            prefs.setStringList(groupKey, groupMDataKey);
            print('groupMDataKey[$groupKey] groupMDataValue[$groupMDataKey]');
          }

          if (key.length == 2) {
            groupLDataKey.add(key);
          }
        }
        var groupLDataKeyStr = '_';
        prefs.setStringList(groupLDataKeyStr, groupLDataKey);
        print(
            'groupLDataKey[$groupLDataKeyStr] groupLDataValue[$groupLDataKey]');
      }

      print(prefs.getKeys().length);
    }
    return prefs;
  }

  Future<int> parseData(List<String> assetDatas) async {
    final prefs = await SharedPreferences.getInstance();
    // snapshot은 Future 클래스가 포장하고 있는 객체를 data 속성으로 전달
    // Future<String>이기 때문에 data는 String이 된다.
    final contents = assetDatas;
    for (var content in contents) {
      final rows = content.split('\n');

      List<String> groupLDataKey = [];
      for (var row in rows) {
        if (row.split(":").length != 2) {
          continue;
        }
        var key = row.split(":")[0];
        var value = row.split(":")[1];

        prefs.setString(key, value);
        print('key[$key] value[$value]');

        List<String> groupMDataKey = [];
        for (var savedKey in prefs.getKeys().toList()) {
          if (key.length + 2 == savedKey.length && savedKey.startsWith(key)) {
            groupMDataKey.add(savedKey);
          }
        }
        if (groupMDataKey.length > 0) {
          var groupKey = key + '_';
          prefs.setStringList(groupKey, groupMDataKey);
          print('groupMDataKey[$groupKey] groupMDataValue[$groupMDataKey]');
        }

        if (key.length == 2) {
          groupLDataKey.add(key);
        }
      }
      var groupLDataKeyStr = '_';
      prefs.setStringList(groupLDataKeyStr, groupLDataKey);
      print('groupLDataKey[$groupLDataKeyStr] groupLDataValue[$groupLDataKey]');
    }

    print(prefs.getKeys().length);
    return prefs.getKeys().length;
  }
}
