class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  /// Resistance can be any integer -, 0, +
  static isValidResistance(int resistance) {
    return true;
  }

  /// Number of sets must be positive
  static isValidNumberOfSets(int numberOfSets) {
    return numberOfSets > 0;
  }

  /// Depth must be positive
  static isDepthValid(int depth) {
    return depth > 0;
  }

  /// Any time field must be positive
  static isValidTime(int seconds) {
    return seconds > 0;
  }

  /// Number of hangs in a set must be positive
  static isValidHangsPerSet(int hangsPerSet) {
    return hangsPerSet > 0;
  }
}
