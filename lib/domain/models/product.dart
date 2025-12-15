// ... [Product] modelinin tam kodunu buraya yapıştırın ...
// (ID, url, currentPrice, name, vb. içeren sınıf)
// lib/domain/models/product.dart

class Product {
  final String id;
  final String userId; // <-- YENİ: Hangi kullanıcıya ait olduğunu tutar
  final String url;
  final String name;
  final String? imageUrl; // <-- YENİ: Görsel URL'si (null olabilir)
  
  final double initialPrice;
  final double currentPrice;
  final DateTime dateAdded;

  // Fiyat geçmişini listeleyeceğiz. Daha sonra ProductPrice tipini tanımlayacağız.
  // Şimdilik Map kullanabiliriz. (Daha profesyonel: List<ProductPrice>)
  final List<Map<String, dynamic>>? priceHistory; // <-- YENİ: Fiyat geçmişi verisi

  Product({
    required this.id,
    required this.userId, // <-- Constructor'a ekledik
    required this.url,
    required this.currentPrice,
    required this.name,
    this.imageUrl, // <-- Opsiyonel yaptık
    required this.initialPrice,
    required this.dateAdded,
    this.priceHistory, // <-- Opsiyonel yaptık
  });
  
  // Eşitlik kontrolü (==) metodu da güncellenmelidir.
  // ... (Bu kısmı değiştirmeyi unutmayın, yoksa linter uyarısı alırsınız)

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    // 'package:collection' kullanmak bu kısmı basitleştirir, ancak şimdilik manuel devam edelim.
    return other is Product &&
        other.id == id &&
        other.userId == userId && // Yeni alan
        other.url == url &&
        other.currentPrice == currentPrice &&
        other.name == name &&
        other.imageUrl == imageUrl && // Yeni alan
        other.initialPrice == initialPrice &&
        other.dateAdded == dateAdded;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^ // Yeni alan
      url.hashCode ^
      currentPrice.hashCode ^
      name.hashCode ^
      imageUrl.hashCode ^ // Yeni alan
      initialPrice.hashCode ^
      dateAdded.hashCode;
}