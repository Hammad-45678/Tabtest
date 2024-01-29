// api_exceptions.dart

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => 'API Exception: $message';
}

class HttpClientException extends ApiException {
  HttpClientException(String message) : super(message);
}

class SocketExceptionWrapper extends ApiException {
  SocketExceptionWrapper(String message) : super(message);

  // Add a helper method to check if the exception is due to network unreachable
  bool get isNetworkUnreachable =>
      message.toLowerCase().contains('network is unreachable');
}

class NetworkUnavailableException extends SocketExceptionWrapper {
  NetworkUnavailableException(String message) : super(message);
}

class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message);
}

// Add more specific exception classes as needed
// ...

