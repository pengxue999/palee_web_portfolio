class ProvinceModel {
  final int provinceId;
  final String provinceName;

  ProvinceModel({required this.provinceId, required this.provinceName});
  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      provinceId: json['province_id'] as int,
      provinceName: json['province_name'] as String,
    );
  }
  toJson() {
    return {
      'province_id': provinceId,
      'province_name': provinceName,
    };
  }
}
