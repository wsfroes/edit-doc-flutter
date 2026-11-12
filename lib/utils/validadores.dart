class Validadores {
  static String? validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe seu nome completo';
    }
    if (valor.trim().length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres';
    }
    return null;
  }

  static String? validarEmail(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe seu e-mail';
    }
    final regexEmail = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!regexEmail.hasMatch(valor.trim())) {
      return 'Digite um e-mail válido (ex: nome@dominio.com)';
    }
    return null;
  }

  static String? validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Informe sua senha';
    }
    if (valor.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  static String? validarCampoObrigatorio(String? valor, String nomeCampo) {
    if (valor == null || valor.trim().isEmpty) {
      return 'O campo $nomeCampo é obrigatório';
    }
    return null;
  }
}