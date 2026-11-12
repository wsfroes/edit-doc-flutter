class Documento {
  final String id;
  final String titulo;
  final String conteudo;
  final String autorEmail;
  final DateTime dataEdicao;

  Documento({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.autorEmail,
    required this.dataEdicao,
  });

  Documento copyWith({
    String? titulo,
    String? conteudo,
    DateTime? dataEdicao,
  }) {
    return Documento(
      id: id,
      titulo: titulo ?? this.titulo,
      conteudo: conteudo ?? this.conteudo,
      autorEmail: autorEmail,
      dataEdicao: dataEdicao ?? this.dataEdicao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'conteudo': conteudo,
      'autorEmail': autorEmail,
      'dataEdicao': dataEdicao.toIso8601String(),
    };
  }

  factory Documento.fromMap(Map<String, dynamic> map) {
    return Documento(
      id: map['id'] ?? '',
      titulo: map['titulo'] ?? '',
      conteudo: map['conteudo'] ?? '',
      autorEmail: map['autorEmail'] ?? '',
      dataEdicao: DateTime.tryParse(map['dataEdicao'] ?? '') ?? DateTime.now(),
    );
  }
}