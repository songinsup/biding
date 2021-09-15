import 'package:flutter/services.dart';

import 'data_load.dart';

class PreWork {
  // assets 폴더 아래에 2016_GDP.txt 파일 있어야 함.
  // AssetBundle 객체를 통해 리소스에 접근.
  // DefaultAssetBundle 클래스 또는 미리 만들어 놓은 rootBundle 객체 사용.
  // async는 비동기 함수, await는 비동기 작업이 종료될 때까지 기다린다는 뜻.
  // 그러나, 함수 자체가 블록되지는 않고 예약 전달의 형태로 함수 반환됨.
  // 따라서 Future 클래스를 사용하기 위해서는 FutureBuilder 등의 특별한 클래스가 필요함.
  Future<int> loadAsset(List<String> paths) async {
    List<String> assetDataList = [];
    for (var path in paths) {
      assetDataList.add(await rootBundle.loadString(path));
    }
    int result = await DataLoad().parseData(assetDataList);
    return result;
  }
}
