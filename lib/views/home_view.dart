import 'package:flutter/material.dart';
import '../models/documento.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';

class HomeView extends StatefulWidget {
  final AuthViewModel authViewModel;
  final DocumentosViewModel documentosViewModel;

  const HomeView({
    super.key,
    required this.authViewModel,
    required this.documentosViewModel,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    final email = widget.authViewModel.usuarioAtual?.email;
    if (email != null) {
      widget.documentosViewModel.carregarDocumentos(email);
    }
  }

  void _abrirEditor({Documento? documento}) {
    Navigator.pushNamed(context, '/editor', arguments: documento);
  }

  @override
  Widget build(BuildContext context) {
    final usuario = widget.authViewModel.usuarioAtual;

    return Scaffold(
      appBar: AppBar(
        title: Text('Documentos de ${usuario?.nome ?? 'Usuário'}'),
        actions: [
          ListenableBuilder(
            listenable: widget.authViewModel,
            builder: (context, _) {
              return IconButton(
                tooltip: 'Alternar Tema',
                icon: Icon(
                  widget.authViewModel.temaEscuro
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  widget.authViewModel.alternarTema(!widget.authViewModel.temaEscuro);
                },
              );
            },
          ),
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await widget.authViewModel.logout();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.documentosViewModel,
        builder: (context, _) {
          if (widget.documentosViewModel.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = widget.documentosViewModel.documentos;
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum documento encontrado.\nClique no botão + para criar o primeiro!',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: Text(
                    doc.titulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    doc.conteudo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _abrirEditor(documento: doc),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      if (usuario != null) {
                        widget.documentosViewModel.excluirDocumento(doc.id, usuario.email);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirEditor(),
        icon: const Icon(Icons.add),
        label: const Text('Novo Documento'),
      ),
    );
  }
}