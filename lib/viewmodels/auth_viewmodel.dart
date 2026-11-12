import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/services/preferences_service.dart';
import '../models/services/documento_storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  final PreferencesService _prefsService = PreferencesService();
  final DocumentoStorageService _storageService = DocumentoStorageService();

  Usuario? _usuarioAtual;
  bool _temaEscuro = false;
  bool _carregando = false;
  String? _mensagemErro;

  Usuario? get usuarioAtual => _usuarioAtual;
  bool get temaEscuro => _temaEscuro;
  bool get carregando => _carregando;
  String? get mensagemErro => _mensagemErro;

  Future<void> inicializar() async {
    _temaEscuro = await _prefsService.carregarTemaEscuro();
    final emailSalvo = await _prefsService.carregarSessao();
    if (emailSalvo != null) {
      final usuarios = await _storageService.listarUsuarios();
      try {
        _usuarioAtual = usuarios.firstWhere((u) => u.email == emailSalvo);
      } catch (_) {
        _usuarioAtual = null;
      }
    }
    notifyListeners();
  }

  Future<void> alternarTema(bool valor) async {
    _temaEscuro = valor;
    await _prefsService.salvarTemaEscuro(valor);
    notifyListeners();
  }

  Future<bool> login(String email, String senha) async {
    _carregando = true;
    _mensagemErro = null;
    notifyListeners();

    final usuarios = await _storageService.listarUsuarios();
    try {
      final encontrado = usuarios.firstWhere(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase() && u.senha == senha,
      );
      _usuarioAtual = encontrado;
      await _prefsService.salvarSessao(encontrado.email);
      _carregando = false;
      notifyListeners();
      return true;
    } catch (_) {
      _mensagemErro = 'E-mail ou senha inválidos.';
      _carregando = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required bool usarTemaEscuro,
  }) async {
    _carregando = true;
    _mensagemErro = null;
    notifyListeners();

    final usuarios = await _storageService.listarUsuarios();
    final jaExiste = usuarios.any(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
    );

    if (jaExiste) {
      _mensagemErro = 'Este e-mail já está cadastrado.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    final novoUsuario = Usuario(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome.trim(),
      email: email.trim().toLowerCase(),
      senha: senha,
    );

    await _storageService.salvarUsuario(novoUsuario);
    await alternarTema(usarTemaEscuro);
    _usuarioAtual = novoUsuario;
    await _prefsService.salvarSessao(novoUsuario.email);

    _carregando = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _usuarioAtual = null;
    await _prefsService.limparSessao();
    notifyListeners();
  }
}