class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    //todo change regex after testing is over
    // r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
    r'^.*\d{6,}$',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email.trim());
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password.trim());
  }
}