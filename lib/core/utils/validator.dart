class Validator {

  static bool isEmpty(String value) {
    value = value.trim();
    return value.isEmpty;
  }

  static bool isIntegerNumber(String value) {
    value = value.trim();
    return RegExp(r'^[0-9]*$').hasMatch(value);
  }

  static bool isEmailAddressValid(String value) {
    value = value.trim();
    return RegExp(r'\S+@\S+\.\S+').hasMatch(value);
  }

  static bool isPhoneNumberValid(String value) {
    value = value.trim();
    if(!value.startsWith('010') && !value.startsWith('011') && !value.startsWith('012') && !value.startsWith('015')) {return false;}
    else if(!isIntegerNumber(value)) {return false;}
    else if(value.length != 11) {return false;}
    else {return true;}
  }
}