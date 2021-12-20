class Validator {
  static String? validateName({required String? name}) {
    // ignore: unnecessary_null_comparison
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'O nome não pode ser vazio';
    }
    return null;
  }

  static String? validateEmail({required String? email}) {
    // ignore: unnecessary_null_comparison
    if (email == null) {
      return null;
    }
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (email.isEmpty) {
      return 'O email não pode ser vazio ';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Introduza um email válido';
    }
    return null;
  }

  static String? validatePassword({required String? password}) {
    // ignore: unnecessary_null_comparison
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return 'A senha não pode ser vazia';
    } else if (password.length < 6) {
      return 'Introduza uma senha com pelo menos 6 caracteres';
    }
    return null;
  }
}
