extension Validation on String {
  String? get isValidMobileNumber => _isValidMobileNumber(value: this);

  String? _isValidMobileNumber({String? value}) {
    if (value == null ||
        value == '' ||
        value.isEmpty ||
        value.trim().length != 10) {
      return 'Invalid mobile number';
    } else {
      return null;
    }
  }
}
