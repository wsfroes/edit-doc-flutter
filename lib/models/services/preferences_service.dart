import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _chaveTemaEscuro = 'tema_escuro';
  static const _chaveEmailLogado = 'usuario_logado_email';

  Future<void> salvarTemaEscuro(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveTemaEscuro, isDark);
  }

  Future<bool> carregarTemaEscuro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chaveTemaEscuro) ?? false;
  }

  Future<void> salvarSessao(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveEmailLogado, email);
  }

  Future<String?> carregarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chaveEmailLogado);
  }

  Future<void> limparSessao() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveEmailLogado);
  }
}