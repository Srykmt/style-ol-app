// lib/domain/user_repository.dart

import 'models/user.dart';

// Modül III'ün devamı: Kullanıcı Yönetimi Sözleşmesi (Interface)
abstract class UserRepository {
  // 1. Mevcut (oturum açmış) kullanıcının bilgilerini getirir.
  //    Stream kullanmak, kullanıcının profilinde (ad, fotoğraf) bir değişiklik olursa
  //    UI'ın otomatik güncellenmesini sağlar.
  Stream<User?> getCurrentUser();

  // 2. Kullanıcının e-posta ve şifre ile oturum açmasını sağlar.
  Future<void> signInWithEmail(String email, String password);

  // 3. Oturumu kapatır.
  Future<void> signOut();

  // 4. Yeni kullanıcı kaydı yapar.
  Future<void> signUp(String email, String password, String name);

  // 5. Mevcut kullanıcının profil bilgilerini (ad, fotoğraf vb.) günceller.
  Future<void> updateProfile({String? name, String? photoUrl});
}