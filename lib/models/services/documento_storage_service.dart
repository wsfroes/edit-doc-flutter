import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../usuario.dart';
import '../documento.dart';

class DocumentoStorageService {
  static const _chaveUsuarios = 'tabela_usuarios_json';
  static const _chaveDocumentos = 'tabela_documentos_json';

  // --- OPERAÇÕES DE USUÁRIO ---
  Future<List<Usuario>> listarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_chaveUsuarios);
    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> listaDecodificada = jsonDecode(jsonString);
    return listaDecodificada.map((item) => Usuario.fromMap(item)).toList();
  }

  Future<void> salvarUsuario(Usuario novoUsuario) async {
    final prefs = await SharedPreferences.getInstance();
    final usuarios = await listarUsuarios();
    usuarios.add(novoUsuario);
    final jsonString = jsonEncode(usuarios.map((u) => u.toMap()).toList());
    await prefs.setString(_chaveUsuarios, jsonString);
  }

  // --- OPERAÇÕES CRUD DE DOCUMENTOS ---
  Future<List<Documento>> listarDocumentosPorUsuario(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_chaveDocumentos);
    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> listaDecodificada = jsonDecode(jsonString);
    final todos = listaDecodificada.map((item) => Documento.fromMap(item)).toList();
    return todos.where((doc) => doc.autorEmail == email).toList();
  }

  Future<void> adicionarDocumento(Documento doc) async {
    final todos = await _carregarTodosDocumentos();
    todos.add(doc);
    await _persistirDocumentos(todos);
  }

  Future<void> atualizarDocumento(Documento docAtualizado) async {
    final todos = await _carregarTodosDocumentos();
    final index = todos.indexWhere((d) => d.id == docAtualizado.id);
    if (index != -1) {
      todos[index] = docAtualizado;
      await _persistirDocumentos(todos);
    }
  }

  Future<void> removerDocumento(String id) async {
    final todos = await _carregarTodosDocumentos();
    todos.removeWhere((d) => d.id == id);
    await _persistirDocumentos(todos);
  }

  Future<List<Documento>> _carregarTodosDocumentos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_chaveDocumentos);
    if (jsonString == null || jsonString.isEmpty) return [];
    final List<dynamic> lista = jsonDecode(jsonString);
    return lista.map((item) => Documento.fromMap(item)).toList();
  }

  Future<void> _persistirDocumentos(List<Documento> lista) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(lista.map((d) => d.toMap()).toList());
    await prefs.setString(_chaveDocumentos, jsonString);
  }
}