import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/user_repository.dart';
import '../domain/models/user.dart';

class FirebaseUserRepository implements UserRepository {
  // Firebase servislerinin örneklerini tutar
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseUserRepository({
    firebase_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // Firestore'daki 'users' koleksiyonunun referansı
  CollectionReference get _usersCollection => _firestore.collection('users');

  // ------------------------------------------------------------------
  //  HELPER METOT: Firebase'den Gelen Veriyi Domain Modelimize Çevirme
  // ------------------------------------------------------------------

  // Firebase Auth Kullanıcısını ve Firestore'daki özel verisini (username, birthYear) birleştirir.
  // Bu, DTO/Entity çevirme işlemidir.
  Future<User?> _userFromFirebase(firebase_auth.User? firebaseUser) async {
    if (firebaseUser == null) {
      return null;
    }
    
    // Firestore'dan kullanıcının özel verilerini çekiyoruz (username, birthYear vb.)
    final docSnapshot = await _usersCollection.doc(firebaseUser.uid).get();
    final userData = docSnapshot.data() as Map<String, dynamic>?; 

    // Verileri birleştiriyoruz
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email!,
      
      // Kullanıcı adı: Firestore'dan çekilir.
      username: userData?['username'] as String? ?? 'Misafir', 
      birthYear: userData?['birthYear'] as int?,
      
      // name, photoUrl: Firebase Auth'tan veya Firestore'dan çekilebilir.
      name: firebaseUser.displayName, 
      photoUrl: firebaseUser.photoURL,
      
      createdAt: firebaseUser.metadata.creationTime!,
    );
  }

  // ------------------------------------------------------------------
  //  REPOSITORY METOTLARININ UYGULANMASI
  // ------------------------------------------------------------------

  @override
  Stream<User?> getCurrentUser() {
    // Firebase Auth durum değişikliklerini dinler ve her Auth olayını _userFromFirebase ile çevirir.
    return _auth.authStateChanges().asyncMap(_userFromFirebase); 
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Hata yönetimi (daha sonra Use Case katmanında daha temiz hale getirilebilir)
      throw e; 
    } catch (e) {
      throw Exception('Bilinmeyen oturum açma hatası: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> signUp(String email, String password, String name, String username, {int? birthYear}) async {
    try {
      // 1. Firebase Auth ile kayıt ol
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // 2. Auth'taki temel profili güncelle
      await userCredential.user!.updateDisplayName(name);

      // 3. Firestore'a özel bilgileri kaydet
      await _usersCollection.doc(uid).set({
        'username': username,
        'birthYear': birthYear,
        'name': name, // Auth'ta da olsa, Firestore'da da tutmak faydalıdır.
        'email': email,
      });

    } on firebase_auth.FirebaseAuthException catch (e) {
      throw e;
    }
  }

  @override
  Future<void> updateProfile({String? name, String? photoUrl, String? username, int? birthYear}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Oturum açmış kullanıcı bulunamadı.');
    }
    
    // Auth güncellemesi (displayName ve photoURL için)
    if (name != null) {
      await user.updateDisplayName(name);
    }
    if (photoUrl != null) {
      await user.updatePhotoURL(photoUrl);
    }
    
    // Firestore'da özel verilerin güncellenmesi
    final updates = <String, dynamic>{};
    if (username != null) {
      updates['username'] = username;
    }
    if (birthYear != null) {
      updates['birthYear'] = birthYear;
    }
    if (name != null) { 
      updates['name'] = name;
    }

    if (updates.isNotEmpty) {
      await _usersCollection.doc(user.uid).update(updates);
    }
  }
}