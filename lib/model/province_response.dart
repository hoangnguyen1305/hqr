import 'package:hqr/utils/convert_utils.dart';

class ProvinceModel {
  final String code;
  final String name;

  const ProvinceModel({this.code = '', this.name = ''});

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
    code: ConvertUtils.getString(json['code']),
    name: ConvertUtils.getString(json['name']),
  );

  factory ProvinceModel.all() => ProvinceModel(code: '00', name: 'Tất cả');

  bool get isAll => code == '00';
}
