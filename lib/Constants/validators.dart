class PasswordValidator {
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
  );

  static bool isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}
