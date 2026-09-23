import 'package:dio/dio.dart';
import 'package:factus_app/core/constants/app_errors.dart';
import 'package:factus_app/core/exceptions/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException Tests', () {
    test('connectionTimeout should return correct timeout error message', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final appException = AppException.fromDioError(dioError);

      expect(appException.message, equals(AppErrorMessages.connectionTimeout));
    });

    test('connectionError should return no internet error message', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      final appException = AppException.fromDioError(dioError);

      expect(appException.message, equals(AppErrorMessages.noInternet));
    });

    test('badResponse 401 should return unauthorized error message', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
        ),
      );

      final appException = AppException.fromDioError(dioError);

      expect(appException.message, equals(AppErrorMessages.unauthorized));
      expect(appException.code, equals('unauthorized'));
    });

    test('badResponse 422 should return validation error message', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 422,
          data: {
            'data': {
              'errors': {
                'email': ['El correo es inválido']
              }
            }
          },
        ),
      );

      final appException = AppException.fromDioError(dioError);

      expect(appException.message, equals('El correo es inválido'));
      expect(appException.code, equals('validation_error'));
    });
  });
}
