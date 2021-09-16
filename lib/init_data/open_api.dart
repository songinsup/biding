import 'dart:convert';
import 'dart:convert' as convert;

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ManageOpenApi {
  ///품목 정보 조회(http)
  Future<List> getSpciesInfo(mKey) async {
    var domain = 'apis.data.go.kr';
    var encodedPath =
        '/B552895/openapi/service/AgpdStdCodeService/getAgpdStdProductList';
    var serviceKey =
        'oNkvjjLGUKoaVi+2lv/vznwlLxP4R5zsGgIO/DRcQkdM3SMTffR5ZB6KIZhqUKjdl7aMc+73H+zY0ECvAsvnyA==';
    var param = {
      'serviceKey': serviceKey,
      'numOfRows': '100',
      'pageNo': '1',
      '_type': 'json',
      'catgoryCd': mKey.substring(0, 2),
      'prdlstCd': mKey
    };
    var itemList = await _getHttp(domain, encodedPath, param);

    List<Map<String, dynamic>> resultList = [];
    for (var eachItem in itemList) {
      Map<String, dynamic> map = {};
      map.putIfAbsent('stdSpciesCode', () => eachItem['stdSpciesCode']);
      map.putIfAbsent('stdSpciesCodeNm', () => eachItem['stdSpciesCodeNm']);
      resultList.add(map);
    }
    return resultList;
  }

  ///도매시장코드 정보 조회
  Future<List> getWltInfo() async {
    //http://openapi.epis.or.kr/openapi/service/CodeListService/getWltCodeList?serviceKey=oNkvjjLGUKoaVi%2B2lv%2FvznwlLxP4R5zsGgIO%2FDRcQkdM3SMTffR5ZB6KIZhqUKjdl7aMc%2B73H%2BzY0ECvAsvnyA%3D%3D&numOfRows=100
    var domain = 'openapi.epis.or.kr';
    var encodedPath = '/openapi/service/CodeListService/getWltCodeList';
    var serviceKey =
        'oNkvjjLGUKoaVi+2lv/vznwlLxP4R5zsGgIO/DRcQkdM3SMTffR5ZB6KIZhqUKjdl7aMc+73H+zY0ECvAsvnyA==';
    var param = {
      'serviceKey': serviceKey,
      'numOfRows': '1000',
      'pageNo': '1',
      '_type': 'json'
    };
    var itemList = await _getHttp(domain, encodedPath, param);

    List<Map<String, dynamic>> resultList = [];
    for (var eachItem in itemList) {
      Map<String, dynamic> map = {};
      map.putIfAbsent('marketco', () => eachItem['marketco']);
      map.putIfAbsent('marketnm', () => eachItem['marketnm']);
      resultList.add(map);
    }
    return resultList;
  }

  ///도매시장코드 정보 조회
  Future<List> getWltprInfo(marketCode) async {
    //http://openapi.epis.or.kr/openapi/service/CodeListService/getWltprCodeList?serviceKey=oNkvjjLGUKoaVi%2B2lv%2FvznwlLxP4R5zsGgIO%2FDRcQkdM3SMTffR5ZB6KIZhqUKjdl7aMc%2B73H%2BzY0ECvAsvnyA%3D%3D&MARKETCODE=310401
    var domain = 'openapi.epis.or.kr';
    var encodedPath = '/openapi/service/CodeListService/getWltprCodeList';
    var serviceKey =
        'oNkvjjLGUKoaVi+2lv/vznwlLxP4R5zsGgIO/DRcQkdM3SMTffR5ZB6KIZhqUKjdl7aMc+73H+zY0ECvAsvnyA==';
    var param = {
      'serviceKey': serviceKey,
      'numOfRows': '1000',
      'pageNo': '1',
      '_type': 'json'
    };
    if (marketCode != null) {
      param['MARKETCODE'] = marketCode;
    }
    var itemList = await _getHttp(domain, encodedPath, param);

    List<Map<String, dynamic>> resultList = [];
    for (var eachItem in itemList) {
      Map<String, dynamic> map = {};
      map.putIfAbsent('cocode', () => eachItem['cocode']);
      map.putIfAbsent('coname', () => eachItem['coname']);
      resultList.add(map);
    }
    return resultList;
  }

  ///도매시장별 경매정보
  Future<List> getRltmAucBrkInfo(dates, scode, marketco, cocode) async {
    //http://openapi.epis.or.kr/openapi/service/RltmAucBrknewsService/getWltRltmAucBrknewsList?serviceKey=oNkvjjL...&dates=20120827&lcode=01&mcode=0101&scode=010100&marketco=110001&cocode=110001
    var domain = 'openapi.epis.or.kr';
    var encodedPath = '/openapi/service/RltmAucBrknewsService/getPrdlstRltmAucBrknewsList';
    var serviceKey =
        'oNkvjjLGUKoaVi+2lv/vznwlLxP4R5zsGgIO/DRcQkdM3SMTffR5ZB6KIZhqUKjdl7aMc+73H+zY0ECvAsvnyA==';
    var param = {
      'serviceKey': serviceKey,
      'dates': '1000',
      'lcode': '1000',
      'mcode': '1000',
      'scode': '1000',
      'marketco': '1000',
      'cocode': '1000',
      'pageNo': '1',
      '_type': 'json'
    };

    var itemList = await _getHttp(domain, encodedPath, param);

    List<Map<String, dynamic>> resultList = [];
    for (var eachItem in itemList) {
      Map<String, dynamic> map = {};
      map.putIfAbsent('cocode', () => eachItem['cocode']);
      map.putIfAbsent('coname', () => eachItem['coname']);
      resultList.add(map);
    }
    return resultList;
  }

  ///http api호출 공통
  Future<List> _getHttp(domain, encodedPath, param) async {
    var url = Uri.http(domain, encodedPath, param);

    print(url.toString());
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(utf8.decode(response.bodyBytes));
      var mapResponse = jsonResponse as Map<String, dynamic>;
      // print('result json[$jsonResponse]');
      // print('result map[$mapResponse]');
      if (mapResponse['response']['body']['items'] == "") {
        return [{}];
      }
      print(mapResponse['response']['body']['items']['item']);
      var itemList = mapResponse['response']['body']['items']['item'];
      if (itemList is Map) {
        itemList = [itemList];
      }
      return itemList;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return [{}];
  }

  ///품목 정보 조회(dio)
  Future<void> getDataDio(String lkey, String mKey) async {
    String serviceKey =
        'oNkvjjLGUKoaVi+2lv/vznwlLxP4R5zsGgIO/DRcQkdM3SMTffR5ZB6KIZhqUKjdl7aMc+73H+zY0ECvAsvnyA==';
    var encodedPath =
        '/B552895/openapi/service/AgpdStdCodeService/getAgpdStdProductList';
    var dio = Dio(
      BaseOptions(
        baseUrl: "http://apis.data.go.kr",
        queryParameters: {
          'serviceKey': serviceKey,
          'numOfRows': '100',
          'pageNo': '1',
          '_type': 'json',
          'catgoryCd': lkey,
          'prdlstCd': mKey
        },
      ),
    );

    var response = await dio.get(encodedPath, queryParameters: {});

    if (response.statusCode == 200) {
      print(response.data);
      var jsonResponse = convert.jsonDecode(utf8.decode(response.data));
      var mapResponse = jsonResponse as Map<String, dynamic>;
      print('result json[$jsonResponse]');
      print('result map[$mapResponse]');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
