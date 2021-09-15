import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ManageOpenApi {
  getSDataHttp(String mKey) {
    String serviceKey =
        'oNkvjjLGUKoaVi+2lv/vznwlLxP4R5zsGgIO/DRcQkdM3SMTffR5ZB6KIZhqUKjdl7aMc+73H+zY0ECvAsvnyA==';
    var encodedPath =
        '/B552895/openapi/service/AgpdStdCodeService/getAgpdStdProductList';
    var url = Uri.http('apis.data.go.kr', encodedPath, {
      'serviceKey': serviceKey,
      'numOfRows': '100',
      'pageNo': '1',
      '_type': 'json',
      'catgoryCd': mKey.substring(0,2),
      'prdlstCd': mKey
    });

    // Await the http get response, then decode the json-formatted response.
    print(url.toString());
    Future<Map<String, dynamic>> response = getResponse(url);
    if (response) {
      var jsonResponse = convert.jsonDecode(utf8.decode(response.bodyBytes));
      var mapResponse = jsonResponse as Map<String, dynamic>;
      // print('result json[$jsonResponse]');
      print('result map[$mapResponse]');
      print(mapResponse['response']['body']['items']['item']);
      List<Map<String, dynamic>> itemList = mapResponse['response']['body']
          ['items']['item'] as List<Map<String, dynamic>>;

      List<Map<String, dynamic>> resultList=[];
      for(var eachItem in itemList){
        Map<String, dynamic> map = {};
        map.putIfAbsent(eachItem['stdSpciesNewCode'], () => eachItem['stdSpciesNewNm']);
        resultList.add(map);
      }
      return resultList;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    };
  }

  Future<Map<String, dynamic>> getResponse(url) async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse as Map<String, dynamic>;
    }else{
      print('Request failed with status: ${response.statusCode}.');
    }
    return {};
  }

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
