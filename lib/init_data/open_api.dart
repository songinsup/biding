import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ManageOpenApi {
  Future<void> getData(String lkey, String mKey) async {

    // var serviceKey='oNkvjjLGUKoaVi%2B2lv%2FvznwlLxP4R5zsGgIO%2FDRcQkdM3SMTffR5ZB6KIZhqUKjdl7aMc%2B73H%2BzY0ECvAsvnyA%3D%3D';
    String serviceKey='oNkvjjLGUKoaVi+2lv/vznwlLxP4R5zsGgIO/DRcQkdM3SMTffR5ZB6KIZhqUKjdl7aMc+73H+zY0ECvAsvnyA==';
    var encodedPath = '/B552895/openapi/service/AgpdStdCodeService/getAgpdStdProductList';
    var url = Uri.http('apis.data.go.kr', encodedPath,
        {'serviceKey':serviceKey,'numOfRows':'100','pageNo':'1','_type':'json','catgoryCd':lkey, 'prdlstCd':mKey});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    // print(response.body);
    if (response.statusCode == 200) {
      // var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var jsonResponse = convert.jsonDecode(utf8.decode(response.bodyBytes));
      var mapResponse = jsonResponse as Map<String, dynamic>;
      // var itemCount = jsonResponse['totalItems'];
      print('result [$jsonResponse]');
      print('result [$mapResponse]');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}