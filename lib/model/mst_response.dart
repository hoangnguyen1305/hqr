import 'package:hqr/utils/convert_utils.dart';

class MSTData {
  final String id;
  final String name;
  final String internationalName;
  final String shortName;
  final String address;

  MSTData({
    this.id = '',
    this.name = '',
    this.internationalName = '',
    this.shortName = '',
    this.address = '',
  });

  factory MSTData.fromJson(Map<String, dynamic> json) => MSTData(
    id: ConvertUtils.getString(json['id']),
    name: ConvertUtils.getString(json['name']),
    internationalName: ConvertUtils.getString(json['internationalName']),
    shortName: ConvertUtils.getString(json['shortName']),
    address: ConvertUtils.getString(json['address']),
  );
}
