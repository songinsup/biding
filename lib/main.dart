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
  static String? date;
  static String? lDataNo;
  static String? mDataNo;
  static String? sDataNo;

  // static late String sDataNo;
  // static late String sDataNo;

  @override
  State<MyStatefulWidget> createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  late Size size;
  late SharedPreferences _sharedPreferences;
  String lDataButtonTitle = "대분류";
  String mDataButtonTitle = "중분류";
  String sDataButtonTitle = "소분류";

  @override
  void initState() {
    super.initState();
    PreWork().loadAsset(['assets/file/mData.txt', 'assets/file/lData.txt']);
    getSharedPreferences();
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
              child: Text(lDataButtonTitle),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context) {
                      return ListData(this)
                          .getListData(context, _sharedPreferences, '_');
                    });
              },
            ),
          ),
          //중분류
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              child: Text(mDataButtonTitle),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context) {
                      return ListData(this).getListData(context,
                          _sharedPreferences, MyStatefulWidget.lDataNo! + '_');
                    });
              },
            ),
          ),
          //소분류
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              child: Text(sDataButtonTitle),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context) {
                      // if (MyStatefulWidget.mDataNo != null) {
                        return ListData(this).getListData(
                            context, _sharedPreferences, MyStatefulWidget.mDataNo);
                      // } else {
                      //   CustomAlert().flutterDialog(context, '확인', '중분류를 선택해 주세요.');
                      // }
                    });

              },
            ),
          ),
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              child: Text("Open api call"),
              onPressed: () {
                if (MyStatefulWidget.mDataNo != null) {
                  ManageOpenApi().getSDataHttp(MyStatefulWidget.mDataNo!);
                  // ManageOpenApi().getDataDio(
                  //     MyStatefulWidget.lDataNo!, MyStatefulWidget.mDataNo!);
                } else {
                  CustomAlert().flutterDialog(context, '확인', '중분류를 선택해 주세요.');
                }
              },
            ),
          )
        ]),
      ),
    );
  }

  void userChoiceEvent(dataType, dataValue) {
    if (dataType == DataType.large) {
      lDataButtonTitle += '(' + dataValue + ')';
    } else if (dataType == DataType.medium) {
      mDataButtonTitle += '(' + dataValue + ')';
    } else if (dataType == DataType.small) {
      sDataButtonTitle += '(' + dataValue + ')';
    }
    setState(() {});
  }
}
