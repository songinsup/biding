import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'init_data/data_load.dart';
import 'init_data/open_api.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('파일 읽기')),
        body: Column(
          children: [
            SingleChildScrollView(
              // 수직 스크롤 지원
              child: FutureBuilder(
                // future: loadAsset(['assets/file/sData.txt','assets/file/mData.txt','assets/file/lData.txt']),
                future: loadAsset(
                    ['assets/file/mData.txt', 'assets/file/lData.txt']),
                builder: (context, snapshot) {
                  //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                  if (snapshot.hasData == false) {
                    return CircularProgressIndicator();
                  }
                  //error가 발생하게 될 경우 반환하게 되는 부분
                  else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  } else {
                    DataLoad().load(snapshot);
                  }
                  return Text("abcd");
                },
              ),
            ),
            Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20)),
                child: Text("Open api call"),
                onPressed:(){
                  ManageOpenApi().getWeather('06','0614');
                }
                ,
              ),
            )
          ],
        ),
      ),
    );
  }

  // assets 폴더 아래에 2016_GDP.txt 파일 있어야 함.
  // AssetBundle 객체를 통해 리소스에 접근.
  // DefaultAssetBundle 클래스 또는 미리 만들어 놓은 rootBundle 객체 사용.
  // async는 비동기 함수, await는 비동기 작업이 종료될 때까지 기다린다는 뜻.
  // 그러나, 함수 자체가 블록되지는 않고 예약 전달의 형태로 함수 반환됨.
  // 따라서 Future 클래스를 사용하기 위해서는 FutureBuilder 등의 특별한 클래스가 필요함.
  Future<List<String>?> loadAsset(List<String> paths) async {
    List<String> result = [];
    for (var path in paths) {
      result.add(await rootBundle.loadString(path));
    }
    return result;
  }
}
