import 'package:flutter/material.dart';
import 'models/documento.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/documentos_viewmodel.dart';
import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/home_view.dart';
import 'views/editor_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authViewModel = AuthViewModel();
  await authViewModel.inicializar();

  final documentosViewModel = DocumentosViewModel();

  runApp(DocEditorApp(
    authViewModel: authViewModel,
    documentosViewModel: documentosViewModel,
  ));
}

class DocEditorApp extends StatelessWidget {
  final AuthViewModel authViewModel;
  final DocumentosViewModel documentosViewModel;

  const DocEditorApp({
    super.key,
    required this.authViewModel,
    required this.documentosViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authViewModel,
      builder: (context, _) {
        return MaterialApp(
          title: 'DocEditor MVVM',
          debugShowCheckedModeBanner: false,
          themeMode: authViewModel.temaEscuro ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            colorSchemeSeed: Colors.indigo,
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: Colors.indigo,
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          initialRoute: authViewModel.usuarioAtual != null ? '/home' : '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (_) => LoginView(authViewModel: authViewModel),
                );
              case '/cadastro':
                return MaterialPageRoute(
                  builder: (_) => CadastroView(authViewModel: authViewModel),
                );
              case '/home':
                return MaterialPageRoute(
                  builder: (_) => HomeView(
                    authViewModel: authViewModel,
                    documentosViewModel: documentosViewModel,
                  ),
                );
              case '/editor':
                final doc = settings.arguments as Documento?;
                return MaterialPageRoute(
                  builder: (_) => EditorView(
                    authViewModel: authViewModel,
                    documentosViewModel: documentosViewModel,
                    documentoExistente: doc,
                  ),
                );
              default:
                return null;
            }
          },
        );
      },
    );
  }
}