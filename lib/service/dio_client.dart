import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hqr/contants/const_res.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ConstRes.apiDomain,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            logCurlRequest(options);
            return handler.next(options);
          },
        ),
      );
    }
  }

  Dio get dio => _dio;
}

void logCurlRequest(RequestOptions options) {
  final method = options.method;
  final headers = options.headers.entries
      .map((e) => '-H "${e.key}: ${e.value}"')
      .join(' ');
  final url = options.uri.toString();

  String data = '';

  if (options.data != null) {
    if (options.data is FormData) {
      final formData = options.data as FormData;
      final fields = formData.fields
          .map((e) => '-F "${e.key}=${e.value}"')
          .join(' ');
      final files = formData.files
          .map((e) {
            final field = e.key;
            final MultipartFile file = e.value;
            final filePath = file.filename ?? 'file';
            return '-F "$field=@$filePath"';
          })
          .join(' ');

      data = '$fields $files';
    } else if (options.data is Map || options.data is List) {
      data = "-d '${jsonEncode(options.data)}'";
    } else {
      data = "-d '${options.data}'";
    }
  }

  final curl = 'curl -X $method $headers $data "$url"';

  log('------ CURL LOG ------');
  log(curl);
}
