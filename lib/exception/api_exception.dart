class ApiException implements Exception {
  final Map<String, dynamic> response;
  ApiException(this.response);

  @override
  String toString() {
    return '${response['message']}';
  }
}
