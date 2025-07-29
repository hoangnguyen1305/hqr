import 'package:hqr/contants/const_res.dart';
import 'package:hqr/model/bank_response.dart';
import 'package:hqr/model/generate_qr_response.dart';
import 'package:hqr/model/mst_response.dart';
import 'package:hqr/service/dio_client.dart';

class ApiService {
  Future<BankResponse> getBanks() async {
    try {
      final response = await DioClient().dio.get(ConstRes.banks);
      return BankResponse.fromJson(response.data);
    } catch (_) {
      return BankResponse();
    }
  }

  Future<GenerateQRResponse> generateQR({
    required Map<String, String> body,
  }) async {
    try {
      final response = await DioClient().dio.post(
        ConstRes.generate,
        data: body,
      );
      return GenerateQRResponse.fromJson(response.data);
    } catch (_) {
      return GenerateQRResponse();
    }
  }

  Future<MSTData> getMST({required String taxCode}) async {
    try {
      final response = await DioClient().dio.get(
        '${ConstRes.business}/$taxCode',
      );
      return MSTData.fromJson(response.data['data']);
    } catch (_) {
      return MSTData();
    }
  }
}
