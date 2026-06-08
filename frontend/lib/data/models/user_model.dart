class UserModel {
  final String id;
  final String nome;
  final String email;
  final bool isActive;
  final String? createdAt;

  const UserModel({
    required this.id,
    required this.nome,
    required this.email,
    this.isActive = true,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'is_active': isActive,
        'created_at': createdAt,
      };

  String get initials {
    final parts = nome.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return nome.isNotEmpty ? nome[0].toUpperCase() : 'U';
  }

  String get firstName => nome.trim().split(' ').first;

  String get memberSince {
    if (createdAt == null) return '';
    try {
      final dt = DateTime.parse(createdAt!);
      const months = [
        'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
        'jul', 'ago', 'set', 'out', 'nov', 'dez'
      ];
      return 'Membro desde ${months[dt.month - 1]}/${dt.year}';
    } catch (_) {
      return '';
    }
  }
}
