import 'package:dio/dio.dart';

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
        return AppException(message: 'Tiempo de espera agotado con el servidor');
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return AppException(message: 'Petición cancelada');
      case DioExceptionType.connectionError:
        return AppException(message: 'Sin conexión a internet');
      default:
        return AppException(message: 'Ocurrió un error inesperado');
    }
  }

  static AppException _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    if (statusCode == 422) {
      final Map<String, dynamic>? errors = data['data']?['errors'];
      String message = 'Error de validación';
      
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
      return AppException(message: 'Sesión expirada o no autorizada', code: 'unauthorized');
    }

    return AppException(
      message: data['message']?.toString() ?? 'Error en el servidor ($statusCode)',
      code: 'server_error',
    );
  }

  @override
  String toString() => message;
}
