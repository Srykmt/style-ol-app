// lib/domain/models/user.dart

class User {
  final String id; 
  final String email;
  final String? name; 
  
  final String username; // <-- Kullanıcı adı (nickname)
  final int? birthYear;    // <-- Doğum Yılı (opsiyonel yaptık)

  final String? photoUrl; 
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.username, // <-- Constructor'a ekledik
    this.birthYear,         // <-- Constructor'a ekledik
    this.name,
    this.photoUrl,
    required this.createdAt,
  });

  // Not: Eğer username benzersiz (unique) olacaksa, bunu Firebase tarafında 
  // Firestore kuralları (Security Rules) ile kontrol etmemiz gerekecek.

  // Eşitlik kontrolü (==) metodu da güncellenmelidir.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.username == username && // YENİ ALAN
        other.birthYear == birthYear && // YENİ ALAN
        other.photoUrl == photoUrl &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      username.hashCode ^ // YENİ ALAN
      birthYear.hashCode ^ // YENİ ALAN
      photoUrl.hashCode ^
      createdAt.hashCode;
}