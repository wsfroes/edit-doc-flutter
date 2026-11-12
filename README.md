# 📱 App de Leitura e Edição de Documentos (Flutter - MVVM)

Repositório template da disciplina de **Desenvolvimento Mobile**, estruturado na arquitetura **MVVM (Model-View-ViewModel)** e preparado para rodar no **GitHub Codespaces** com persistência local (`shared_preferences`) e operações CRUD.

---

## 📂 Estrutura de Pastas (Arquitetura MVVM)

O código-fonte dentro da pasta `lib/` segue a separação de responsabilidades do padrão **MVVM**:

```text
lib/
├── main.dart                         # Ponto de entrada, ThemeData reativo e Rotas Nomeadas
├── models/                           # Camada MODEL: Entidades e Persistência de Dados
│   ├── usuario.dart                  # Entidade Usuario (id, nome, email, senha)
│   ├── documento.dart                # Entidade Documento (id, titulo, conteudo, autorEmail, dataEdicao)
│   └── services/                     # Acesso a dados locais
│       ├── preferences_service.dart  # Persistência Chave-Valor (shared_preferences: tema e preferências)
│       └── banco_local_service.dart  # Simulação de Banco Relacional (CRUD de Usuários e Documentos)
├── viewmodels/                       # Camada VIEWMODEL: Estado da UI e Regras de Negócio (ChangeNotifier)
│   ├── auth_viewmodel.dart           # Lógica de Login, Cadastro e carregamento de preferências
│   └── documentos_viewmodel.dart     # Estado da lista de documentos e operações CRUD
├── views/                            # Camada VIEW: Interface Gráfica (Telas sem regra de negócio)
│   ├── login_view.dart               # Tela de autenticação (/)
│   ├── cadastro_view.dart            # Tela de registro e preferências (/cadastro)
│   ├── home_view.dart                # Biblioteca dinâmica de documentos (/home)
│   └── editor_view.dart              # Tela de criação e edição de documentos (/editor)
└── utils/                            # Utilitários reutilizáveis
    └── validadores.dart              # Validações de formulário (Nome, E-mail estrito e Senha)

---

## 🚀 Como executar o projeto no Codespaces

1. Clique no botão verde **Use this template** $\rightarrow$ **Open in a codespace**.
2. Aguarde o carregamento do ambiente Flutter (cerca de 1 a 2 minutos na primeira inicialização).
3. Pressione a tecla **F5** (ou clique no menu *Run > Start Debugging*).
4. O aplicativo será compilado como servidor web e aberto automaticamente na aba de visualização interna na porta `8080`.

---

Caso tiver apenas o devcontainer.json, ao abrir o codespaces e clicar em "trust folders" para confiar nas pastas. Aplique os seguintes comandos:

1. flutter create . --project-name edit_doc_flutter                 #aqui é pra criar o projeto
2. flutter pub add shared_preferences                               #este  comando é para add o pacote do shared_preferences
3. mkdir -p lib/models/services lib/viewmodels lib/views lib/utils  #criar a estrutura de pastas da arquitetura MVVM
