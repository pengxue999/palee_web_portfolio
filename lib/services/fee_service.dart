import 'package:palee_web_portfolio/utils/http_helper.dart';

import '../models/fee_model.dart';

class FeeService {
  final HttpHelper _http = HttpHelper();

  Future<FeeListResponse> getFees() async {
    final response = await _http.get('/fees');
    return FeeListResponse.fromJson(_http.handleJson(response));
  }
}
