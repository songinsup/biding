import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'contents/alert_dialog.dart';
import 'contents/constants.dart';
import 'contents/item_list_data.dart';
import 'init_data/future_build.dart';
import 'package:intl/intl.dart';

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

  String? _date;
  String? _lDataNo;
  String? _mDataNo;
  String? _sDataNo;
  String? _marketCode;
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

  final DateFormat visibleFormat = DateFormat('yyyy-MM-dd');
  final DateFormat apiDataFormat = DateFormat('yyyyMMdd');
  DateTime currentDate = DateTime.now();
  String? visibleDate;

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

    visibleDate = visibleFormat.format(currentDate);
    _date = apiDataFormat.format(currentDate);
  }


  Future<void> _showCalendar(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        visibleDate = visibleFormat.format(pickedDate);
        _date = apiDataFormat.format(pickedDate);
      });
  }

  void getSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _lastSavedDataLoad(_sharedPreferences);
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
              child: Text(visibleDate!),
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
                          condition: {'upperKey':'_'});
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
                          condition: {'upperKey':_lDataNo! + '_'});
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
                          .getListData(context, 'sData', condition: {'upperKey':_mDataNo});
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
                          .getListData(context, 'wltprInfo', condition: {'marketCode':_marketCode});
                    });
              },
            ),
          ),
          //경매 일별 요약정보 검색버튼
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              child: Text('요약 정보 검색'),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context) {
                      return ListData(this)
                          .getListData(context, 'summary_search',
                          condition: {
                            'dates':_date,
                            'lcode':_lDataNo,
                            'mcode':_mDataNo,
                            'scode':_sDataNo,
                            'marketco':_marketCode,
                            'cocode':_wltprNo,
                          });
                    });
              },
            ),
          ),
          //경매 전체정보 검색버튼
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              child: Text('전체 정보 검색'),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context) {
                      return ListData(this)
                          .getListData(context, 'full_search',
                          condition: {
                            'dates':_date,
                            'lcode':_lDataNo,
                            'mcode':_mDataNo,
                            'scode':_sDataNo,
                            'marketco':_marketCode,
                            'cocode':_wltprNo,
                          });
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
      _sharedPreferences.setString('lDataNoSaved', dateKey);
      _sharedPreferences.setString('lDataNmSaved', dataValue);

      _mDataButtonTitle = _mDataButtonDefaultTitle;
      _mDataNo = null;
      _sDataButtonTitle = _sDataButtonDefaultTitle;
      _sDataNo = null;

      _sharedPreferences.remove('mDataNoSaved');
      _sharedPreferences.remove('mDataNmSaved');
      _sharedPreferences.remove('sDataNoSaved');
      _sharedPreferences.remove('sDataNmSaved');
    } else if (dataType == DataType.medium) {
      _mDataNo = dateKey;
      _mDataButtonTitle = _mDataButtonDefaultTitle + ' (' + dataValue + ')';
      _sharedPreferences.setString('mDataNoSaved', dateKey);
      _sharedPreferences.setString('mDataNmSaved', dataValue);

      _sDataButtonTitle = _sDataButtonDefaultTitle;
      _sDataNo = null;

      _sharedPreferences.remove('sDataNoSaved');
      _sharedPreferences.remove('sDataNmSaved');
    } else if (dataType == DataType.small) {
      _sDataNo = dateKey;
      _sDataButtonTitle = _sDataButtonDefaultTitle + ' (' + dataValue + ')';

      _sharedPreferences.setString('sDataNoSaved', dateKey);
      _sharedPreferences.setString('sDataNmSaved', dataValue);
    } else if (dataType == DataType.wlt) {
      _marketCode = dateKey;
      _wltDataButtonTitle = _wltDataButtonDefaultTitle + ' (' + dataValue + ')';

      _sharedPreferences.setString('marketCodeSaved', dateKey);
      _sharedPreferences.setString('marketNmSaved', dataValue);
    } else if (dataType == DataType.wltpr) {
      _wltprNo = dateKey;
      _wltprDataButtonTitle =
          _wltprDataButtonDefaultTitle + ' (' + dataValue + ')';

      _sharedPreferences.setString('coCodeSaved', dateKey);
      _sharedPreferences.setString('coNmSaved', dataValue);
    }
    setState(() {});
  }

  void _lastSavedDataLoad(_sharedPreferences){
    var lDataNoSaved = _sharedPreferences.getString('lDataNoSaved');
    var lDataNmSaved = _sharedPreferences.getString('lDataNmSaved');
    if(lDataNoSaved!=null && lDataNmSaved!=null){
      _lDataNo=lDataNoSaved;
      _lDataButtonTitle =_lDataButtonDefaultTitle+ ' (' + lDataNmSaved + ')';;
    }

    var mDataNoSaved = _sharedPreferences.getString('mDataNoSaved');
    var mDataNmSaved = _sharedPreferences.getString('mDataNmSaved');
    if(mDataNoSaved!=null && mDataNmSaved!=null){
      _mDataNo=mDataNoSaved;
      _mDataButtonTitle =_mDataButtonDefaultTitle+ ' (' + mDataNmSaved + ')';;
    }

    var sDataNoSaved = _sharedPreferences.getString('sDataNoSaved');
    var sDataNmSaved = _sharedPreferences.getString('sDataNmSaved');
    if(sDataNoSaved!=null && sDataNmSaved!=null){
      _sDataNo=mDataNoSaved;
      _sDataButtonTitle =_sDataButtonDefaultTitle+ ' (' + sDataNmSaved + ')';;
    }

    var marketCodeSaved = _sharedPreferences.getString('marketCodeSaved');
    var marketNmSaved = _sharedPreferences.getString('marketNmSaved');
    if(marketCodeSaved!=null && marketNmSaved!=null){
      _marketCode=marketCodeSaved;
      _wltDataButtonTitle =_wltDataButtonDefaultTitle+ ' (' + marketNmSaved + ')';;
    }

    var coCodeSaved = _sharedPreferences.getString('coCodeSaved');
    var coNmSaved = _sharedPreferences.getString('coNmSaved');
    if(coCodeSaved!=null && coNmSaved!=null){
      _wltprNo=coCodeSaved;
      _wltprDataButtonTitle =_wltprDataButtonDefaultTitle+ ' (' + coNmSaved + ')';;
    }
    setState(() {});
  }
}
