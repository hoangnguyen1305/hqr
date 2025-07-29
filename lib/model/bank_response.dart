import 'package:hqr/utils/convert_utils.dart';

class BankResponse {
  final String code;
  final String desc;
  final List<BankData> data;

  const BankResponse({this.code = '00', this.desc = '', this.data = const []});

  factory BankResponse.fromJson(Map<String, dynamic> json) => BankResponse(
    code: ConvertUtils.getString(json['code']),
    desc: ConvertUtils.getString(json['desc']),
    data: ConvertUtils.getList(json['data'], BankData.fromJson),
  );
}

class BankData {
  final int id;
  final String name;
  final String code;
  final String bin;
  final String shortName;
  final String logo;
  final int transferSupported;
  final int lookupSupported;
  final int support;
  final int isTransfer;
  final String swiftCode;

  const BankData({
    this.id = 0,
    this.name = '',
    this.code = '',
    this.bin = '',
    this.shortName = '',
    this.logo = '',
    this.transferSupported = 0,
    this.lookupSupported = 0,
    this.support = 0,
    this.isTransfer = 0,
    this.swiftCode = '',
  });

  factory BankData.fromJson(Map<String, dynamic> json) => BankData(
    id: ConvertUtils.getInt(json['id']),
    name: ConvertUtils.getString(json['name']),
    code: ConvertUtils.getString(json['code']),
    bin: ConvertUtils.getString(json['bin']),
    shortName: ConvertUtils.getString(json['shortName']),
    logo: ConvertUtils.getString(json['logo']),
    transferSupported: ConvertUtils.getInt(json['transferSupported']),
    lookupSupported: ConvertUtils.getInt(json['lookupSupported']),
    support: ConvertUtils.getInt(json['support']),
    isTransfer: ConvertUtils.getInt(json['isTransfer']),
    swiftCode: ConvertUtils.getString(json['swift_code']),
  );
}
