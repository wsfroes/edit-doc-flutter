import 'package:flutter/material.dart';
import '../models/documento.dart';
import '../models/services/documento_storage_service.dart';

class DocumentosViewModel extends ChangeNotifier {
  final DocumentoStorageService _storageService = DocumentoStorageService();

  List<Documento> _documentos = [];
  bool _carregando = false;

  List<Documento> get documentos => List.unmodifiable(_documentos);
  bool get carregando => _carregando;

  Future<void> carregarDocumentos(String emailUsuario) async {
    _carregando = true;
    notifyListeners();

    _documentos = await _storageService.listarDocumentosPorUsuario(emailUsuario);
    _documentos.sort((a, b) => b.dataEdicao.compareTo(a.dataEdicao));

    _carregando = false;
    notifyListeners();
  }

  Future<void> salvarDocumento({
    String? idExistente,
    required String titulo,
    required String conteudo,
    required String autorEmail,
  }) async {
    if (idExistente == null) {
      final novoDoc = Documento(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: titulo.trim(),
        conteudo: conteudo.trim(),
        autorEmail: autorEmail,
        dataEdicao: DateTime.now(),
      );
      await _storageService.adicionarDocumento(novoDoc);
    } else {
      final atualizado = Documento(
        id: idExistente,
        titulo: titulo.trim(),
        conteudo: conteudo.trim(),
        autorEmail: autorEmail,
        dataEdicao: DateTime.now(),
      );
      await _storageService.atualizarDocumento(atualizado);
    }
    await carregarDocumentos(autorEmail);
  }

  Future<void> excluirDocumento(String id, String autorEmail) async {
    await _storageService.removerDocumento(id);
    await carregarDocumentos(autorEmail);
  }
}