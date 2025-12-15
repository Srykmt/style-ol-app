// lib/data/firebase_product_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/product_repository.dart';
import '../domain/models/product.dart';

// Modül IV: Concrete Repository Sınıfı
class FirebaseProductRepository implements ProductRepository {
  // Firestore veritabanı örneği (Bağlantı nesnesi)
  final FirebaseFirestore _firestore;

  // Yapıcı Metot (Constructor): Uygulama başladığında bu bağlantıyı hazırlar.
  FirebaseProductRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;


  // ----------------------------------------------------
  // Gelen veriyi Product modeline dönüştürme (Helper Metot)
  // ----------------------------------------------------

  Product _productFromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Firebase'deki Timestamp'i Dart'taki DateTime'a çeviriyoruz.
    final Timestamp dateAddedTimestamp = data['dateAdded'] as Timestamp;

    return Product(
      id: doc.id,
      url: data['url'] as String,
      currentPrice: data['currentPrice'] as double,
      name: data['name'] as String,
      initialPrice: data['initialPrice'] as double,
      dateAdded: dateAddedTimestamp.toDate(),
    );
  }


  // ----------------------------------------------------
  // ProductRepository Interface'inden gelen metodları burada uygulayacağız.
  // ----------------------------------------------------


  @override
  Stream<List<Product>> getTrackedProducts() {
    // Veritabanındaki 'products' koleksiyonunu dinlemeye başlar (Stream).
    return _firestore
        .collection('products')
        .snapshots()
        .map((snapshot) {
      
      // Gelen belgeleri Product modeline dönüştürüp liste yapar.
      return snapshot.docs.map((doc) {
        return _productFromDocument(doc);
      }).toList();
    });
  }


  // Şimdilik sadece yer tutucu (Placeholder) olarak kalan metodlar

  @override
  Future<void> addProduct(String url) async {
    // TODO: addProduct metodu daha sonra eklenecek.
    throw UnimplementedError('addProduct metodu henüz uygulanmadı.');
  }

  @override
  Future<void> removeProduct(String productId) async {
    // TODO: removeProduct metodu daha sonra eklenecek.
    throw UnimplementedError('removeProduct metodu henüz uygulanmadı.');
  }
  
  @override
  Future<void> sendPriceAlert(String productId) async {
    // TODO: sendPriceAlert metodu daha sonra eklenecek.
    throw UnimplementedError('sendPriceAlert metodu henüz uygulanmadı.');
  }
}
