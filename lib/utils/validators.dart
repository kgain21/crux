class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static validateEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static validatePassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  /// Resistance can be any integer -, 0, +
  static validateResistance(String resistance) {
    var resistanceValue = int.tryParse(resistance);
    return null != resistanceValue;
  }

  /// Number of sets must be positive
  static validateNumberOfSets(String numberOfSets) {
    var numberOfSetsValue = int.tryParse(numberOfSets);
    if(null == numberOfSetsValue) return false;
    return numberOfSetsValue > 0;
  }

  /// Depth must be positive
  static validateDepth(String depth) {
    var depthValue = double.tryParse(depth);
    if(null == depthValue) return false;
    return depthValue > 0;
  }

  /// Any time field must be positive
  static validateTime(String seconds) {
    int secondsValue = int.tryParse(seconds);
    if(null == secondsValue) return false;
    return secondsValue > 0;
  }

  /// Number of hangs in a set must be positive
  static validateHangsPerSet(String hangsPerSet) {
    var hangsPerSetValue = int.tryParse(hangsPerSet);
    if(null == hangsPerSetValue) return false;
    return hangsPerSetValue > 0;
  }
}
