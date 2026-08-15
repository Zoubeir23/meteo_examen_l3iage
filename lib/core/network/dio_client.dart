import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

/// Builds the shared [Dio] instance used by every API client in the app.
Dio buildDioClient() {
  return Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
}
