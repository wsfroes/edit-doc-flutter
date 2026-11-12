import 'package:flutter/material.dart';
import '../models/documento.dart';
import '../utils/validadores.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';

class EditorView extends StatefulWidget {
  final AuthViewModel authViewModel;
  final DocumentosViewModel documentosViewModel;
  final Documento? documentoExistente;

  const EditorView({
    super.key,
    required this.authViewModel,
    required this.documentosViewModel,
    this.documentoExistente,
  });

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _conteudoController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(
      text: widget.documentoExistente?.titulo ?? '',
    );
    _conteudoController = TextEditingController(
      text: widget.documentoExistente?.conteudo ?? '',
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final email = widget.authViewModel.usuarioAtual?.email;
    if (email == null) return;

    await widget.documentosViewModel.salvarDocumento(
      idExistente: widget.documentoExistente?.id,
      titulo: _tituloController.text,
      conteudo: _conteudoController.text,
      autorEmail: email,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.documentoExistente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar Documento' : 'Novo Documento'),
        actions: [
          IconButton(
            tooltip: 'Salvar',
            icon: const Icon(Icons.check),
            onPressed: _salvar,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título do Documento',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => Validadores.validarCampoObrigatorio(v, 'Título'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _conteudoController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    labelText: 'Conteúdo',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => Validadores.validarCampoObrigatorio(v, 'Conteúdo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}