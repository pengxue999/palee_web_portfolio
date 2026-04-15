class DiscountModel {
  final String discountId;
  final double discountAmount;
  final String discountDescription;
  final String academicYear;

  const DiscountModel({
    required this.discountId,
    required this.discountAmount,
    required this.discountDescription,
    required this.academicYear,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      discountId: json['discount_id'] as String? ?? '',
      discountAmount:
          double.tryParse(json['discount_amount']?.toString() ?? '0') ?? 0,
      discountDescription: json['discount_description'] as String? ?? '',
      academicYear: json['academic_year']?.toString() ?? '',
    );
  }
}

class DiscountListResponse {
  final String code;
  final String messages;
  final List<DiscountModel> data;

  const DiscountListResponse({
    required this.code,
    required this.messages,
    required this.data,
  });

  factory DiscountListResponse.fromJson(Map<String, dynamic> json) {
    return DiscountListResponse(
      code: json['code'] as String? ?? '',
      messages: json['messages'] as String? ?? '',
      data:
          (json['data'] as List?)
              ?.map((e) => DiscountModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
