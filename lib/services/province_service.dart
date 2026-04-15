
import 'package:palee_web_portfolio/models/province_model.dart';
import 'package:palee_web_portfolio/utils/http_helper.dart';

class ProvinceService {
  final HttpHelper _http = HttpHelper();

  Future<ProvinceResponse> getProvinces() async {
    final response = await _http.get('/provinces');
    return ProvinceResponse.fromJson(_http.handleJson(response));
  }
}
