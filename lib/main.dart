import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'contents/alert_dialog.dart';
import 'contents/constants.dart';
import 'contents/item_list_data.dart';
import 'init_data/future_build.dart';
import 'init_data/open_api.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Code Sample',
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  late Size size;

  String? date;
  String? _lDataNo;
  String? _mDataNo;
  String? _sDataNo;
  String? _wltNo;
  String? _wltprNo;

  late SharedPreferences _sharedPreferences;
  static const String _lDataButtonDefaultTitle = "대분류";
  static const String _mDataButtonDefaultTitle = "중분류";
  static const String _sDataButtonDefaultTitle = "소분류";
  static const String _wltDataButtonDefaultTitle = "도매시장";
  static const String _wltprDataButtonDefaultTitle = "도매시장법인";
  String? _lDataButtonTitle;
  String? _mDataButtonTitle;
  String? _sDataButtonTitle;
  String? _wltDataButtonTitle;
  String? _wltprDataButtonTitle;

  @override
  void initState() {
    super.initState();
    PreWork().loadAsset(['assets/file/mData.txt', 'assets/file/lData.txt']);
    getSharedPreferences();
    _lDataButtonTitle = _lDataButtonDefaultTitle;
    _mDataButtonTitle = _mDataButtonDefaultTitle;
    _sDataButtonTitle = _sDataButtonDefaultTitle;
    _wltDataButtonTitle = _wltDataButtonDefaultTitle;
    _wltprDataButtonTitle = _wltprDataButtonDefaultTitle;
  }

  DateTime currentDate = DateTime.now();

  Future<void> _showCalendar(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }

  void getSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('경매정보 조회')),
      body: Container(
        margin: EdgeInsets.all(2),
        child: ListView(children: [
          //calendar
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              child: Text(currentDate.toString()),
              onPressed: () => _showCalendar(context),
            ),
          ),
          //대분류
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              child: Text(_lDataButtonTitle!),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context) {
                      return ListData(this).getListData(context, 'lData',
                          sharedPreferences: _sharedPreferences,
                          condition: '_');
                    });
              },
            ),
          ),
          //중분류
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              child: Text(_mDataButtonTitle!),
              onPressed: () {
                if (_lDataNo == null) {
                  CustomAlert().flutterDialog(context, '확인', '대분류를 선택해 주세요.');
                  return;
                }
                showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context) {
                      return ListData(this).getListData(context, 'mData',
                          sharedPreferences: _sharedPreferences,
                          condition: _lDataNo! + '_');
                    });
              },
            ),
          ),
          //소분류
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              child: Text(_sDataButtonTitle!),
              onPressed: () {
                if (_mDataNo == null) {
                  CustomAlert().flutterDialog(context, '확인', '중분류를 선택해 주세요.');
                  return;
                }
                showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context) {
                      return ListData(this)
                          .getListData(context, 'sData', condition: _mDataNo);
                    });
              },
            ),
          ),
          //도매시장 정보 조회
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              child: Text(_wltDataButtonTitle!),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context) {
                      return ListData(this).getListData(context, 'wltInfo');
                    });
              },
            ),
          ),
          //도매시장법인 정보 조회
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              child: Text(_wltprDataButtonTitle!),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context) {
                      return ListData(this)
                          .getListData(context, 'wltprInfo', condition: _wltNo);
                    });
              },
            ),
          ),
          //검색버튼
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              child: Text('검색'),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context) {
                      return ListData(this)
                          .getListData(context, 'wltprInfo', condition: _wltNo);
                    });
              },
            ),
          ),
        ]),
      ),
    );
  }

  void userChoiceEvent(dataType, dateKey, dataValue) {
    if (dataType == DataType.large) {
      _lDataNo = dateKey;
      _lDataButtonTitle = _lDataButtonDefaultTitle + ' (' + dataValue + ')';

      _mDataButtonTitle = _mDataButtonDefaultTitle;
      _mDataNo = null;
      _sDataButtonTitle = _sDataButtonDefaultTitle;
      _sDataNo = null;
    } else if (dataType == DataType.medium) {
      _mDataNo = dateKey;
      _mDataButtonTitle = _mDataButtonDefaultTitle + ' (' + dataValue + ')';

      _sDataButtonTitle = _sDataButtonDefaultTitle;
      _sDataNo = null;
    } else if (dataType == DataType.small) {
      _sDataNo = dateKey;
      _sDataButtonTitle = _sDataButtonDefaultTitle + ' (' + dataValue + ')';
    } else if (dataType == DataType.wlt) {
      _wltNo = dateKey;
      _wltDataButtonTitle = _wltDataButtonDefaultTitle + ' (' + dataValue + ')';
    } else if (dataType == DataType.wltpr) {
      _wltprNo = dateKey;
      _wltprDataButtonTitle =
          _wltprDataButtonDefaultTitle + ' (' + dataValue + ')';
    }
    setState(() {});
  }
}
