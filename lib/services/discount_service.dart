import 'package:palee_web_portfolio/utils/http_helper.dart';

import '../models/discount_model.dart';

class DiscountService {
  final HttpHelper _http = HttpHelper();

  Future<DiscountListResponse> getDiscounts() async {
    final response = await _http.get('/discounts');
    return DiscountListResponse.fromJson(_http.handleJson(response));
  }
}
