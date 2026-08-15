import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_examen_l3iage/core/constants/api_constants.dart';
import 'package:meteo_examen_l3iage/core/network/dio_client.dart';

void main() {
  test('buildDioClient targets the OpenWeather base URL with sane timeouts', () {
    final dio = buildDioClient();

    expect(dio.options.baseUrl, ApiConstants.baseUrl);
    expect(dio.options.connectTimeout, isNotNull);
    expect(dio.options.receiveTimeout, isNotNull);
  });
}
