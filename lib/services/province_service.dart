import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:palee_web_portfolio/constants/constant.dart';
import 'package:palee_web_portfolio/models/province_model.dart';

class ProvinceService {
  Future<List<ProvinceModel>> fetchAllProvince() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/provinces'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> provinceList = jsonData['data'];
        return provinceList
            .map<ProvinceModel>((json) => ProvinceModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      throw Exception('ບໍ່ສາມາດດຶງຂໍ້ມູນ: $e');
    }
    return [];
  }
}
