extension Validation on String {
  String? get isValidMobileNumber => _isValidMobileNumber(value: this);
  String? get isEmptyString => _emptyStringValidator(value: this);

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

  String? _emptyStringValidator({String? value}) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Please enter value';
    } else {
      return null;
    }
  }
}
