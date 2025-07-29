import 'package:hqr/utils/convert_utils.dart';

class GenerateQRResponse {
  final String code;
  final String desc;
  final QRData data;

  const GenerateQRResponse({
    this.code = '01',
    this.desc = '',
    this.data = const QRData(),
  });

  factory GenerateQRResponse.fromJson(
    Map<String, dynamic> json,
  ) => GenerateQRResponse(
    code: ConvertUtils.getString(json['code']),
    desc: ConvertUtils.getString(json['desc']),
    data: json['data'] != null ? QRData.fromJson(json['data']) : const QRData(),
  );
}

class QRData {
  final int acpId;
  final String accountName;
  final String qrCode;
  final String qrDataURL;

  const QRData({
    this.acpId = 0,
    this.accountName = '',
    this.qrCode = '',
    this.qrDataURL = '',
  });

  factory QRData.fromJson(Map<String, dynamic> json) => QRData(
    acpId: ConvertUtils.getInt(json['acpId']),
    accountName: ConvertUtils.getString(json['accountName']),
    qrCode: ConvertUtils.getString(json['qrCode']),
    qrDataURL: ConvertUtils.getString(json['qrDataURL']),
  );
}
