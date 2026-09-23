class AppErrorMessages {
  // Errores de Red y Conexión
  static const String connectionTimeout = 'Tiempo de espera agotado con el servidor';
  static const String requestCancelled = 'Petición cancelada';
  static const String noInternet = 'Sin conexión a internet';
  static const String unexpectedError = 'Ocurrió un error inesperado';

  // Errores HTTP / Servidor
  static const String validationError = 'Error de validación';
  static const String unauthorized = 'Sesión expirada o no autorizada';

  static String serverError(int? statusCode) {
    if (statusCode != null) {
      return 'Error en el servidor ($statusCode)';
    }
    return 'Error en el servidor';
  }

  // Errores de Negocio / Dominio
  static const String customerNotFound = 'Cliente no encontrado';
  static const String establishmentWithoutId =
      'No se puede actualizar un establecimiento sin id';
}
