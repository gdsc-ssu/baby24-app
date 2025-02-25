class ApiException implements Exception {
  ApiException({
    required this.message,
    this.code,
    this.details,
  });

  final String message;
  final int? code;
  final dynamic details;

  @override
  String toString() {
    return 'ApiException: $message '
        '${code != null ? '(Code: $code)' : ''} '
        '${details != null ? '- $details' : ''}';
  }
}
