class DistrictModel {
  final int districtId;
  final String districtName;
  final int provinceId;

  DistrictModel({
    required this.districtId,
    required this.districtName,
    required this.provinceId,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      districtId: json['district_id'] as int,
      districtName: json['district_name'] as String,
      provinceId: json['province_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'district_id': districtId,
      'district_name': districtName,
      'province_id': provinceId,
    };
  }
}
