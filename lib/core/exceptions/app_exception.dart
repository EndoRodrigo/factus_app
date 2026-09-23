import 'package:dio/dio.dart';
import '../constants/app_errors.dart';

class AppException implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? errors;

  AppException({required this.message, this.code, this.errors});

  factory AppException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(message: AppErrorMessages.connectionTimeout);
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return AppException(message: AppErrorMessages.requestCancelled);
      case DioExceptionType.connectionError:
        return AppException(message: AppErrorMessages.noInternet);
      default:
        return AppException(message: AppErrorMessages.unexpectedError);
    }
  }

  static AppException _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    if (statusCode == 422) {
      final Map<String, dynamic>? errors = data['data']?['errors'];
      String message = AppErrorMessages.validationError;
      
      if (errors != null && errors.isNotEmpty) {
        // Tomamos el primer error para mostrar un mensaje amigable
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          message = firstError.first.toString();
        }
      }
      
      return AppException(
        message: message,
        code: 'validation_error',
        errors: errors,
      );
    }

    if (statusCode == 401) {
      return AppException(
        message: AppErrorMessages.unauthorized,
        code: 'unauthorized',
      );
    }

    return AppException(
      message:
          data['message']?.toString() ?? AppErrorMessages.serverError(statusCode),
      code: 'server_error',
    );
  }

  @override
  String toString() => message;
}
