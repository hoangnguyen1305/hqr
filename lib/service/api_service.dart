import 'package:hqr/contants/const_res.dart';
import 'package:hqr/model/bank_response.dart';
import 'package:hqr/model/generate_qr_response.dart';
import 'package:hqr/model/mst_response.dart';
import 'package:hqr/model/plate_response.dart';
import 'package:hqr/model/province_response.dart';
import 'package:hqr/model/traffic_response.dart';
import 'package:hqr/service/dio_client.dart';
import 'package:hqr/utils/convert_utils.dart';

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

  Future<List<TrafficViolations>> getTrafficViolations({
    required Map<String, dynamic> body,
  }) async {
    try {
      final dio = DioClient().dio.clone();
      dio.options.baseUrl = ConstRes.trafficDomain;
      dio.options.headers['x-api-key'] = ConstRes.trafficApiKey;
      final response = await DioClient().dio.post('', data: body);
      return ConvertUtils.getList<TrafficViolations>(
        response.data['trafficViolations'],
        TrafficViolations.fromJson,
      );
    } catch (_) {
      return [];
    }
  }

  Future<List<ProvinceModel>> getListProvince() async {
    try {
      final dio = DioClient().dio.clone();
      dio.options.baseUrl = ConstRes.auctionDomain;
      final response = await DioClient().dio.get(ConstRes.provinces);
      return ConvertUtils.getList<ProvinceModel>(
        response.data['data'],
        ProvinceModel.fromJson,
      );
    } catch (_) {
      return [];
    }
  }

  Future<PlateResponse> searchPlates({
    required Map<String, dynamic> param,
  }) async {
    try {
      final dio = DioClient().dio.clone();
      dio.options.baseUrl = ConstRes.auctionDomain;
      final response = await DioClient().dio.get(
        ConstRes.search,
        queryParameters: param,
      );
      return PlateResponse.fromJson(response.data);
    } catch (_) {
      return PlateResponse();
    }
  }

  Future<PlateResponse> resultPlates({
    required Map<String, dynamic> param,
  }) async {
    try {
      final dio = DioClient().dio.clone();
      dio.options.baseUrl = ConstRes.auctionDomain;
      final response = await DioClient().dio.get(
        ConstRes.results,
        queryParameters: param,
      );
      return PlateResponse.fromJson(response.data);
    } catch (_) {
      return PlateResponse();
    }
  }
}
