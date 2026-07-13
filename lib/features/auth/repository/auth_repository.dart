import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Uygulama açıldığında mevcut kullanıcının oturumunu ve rolünü kontrol eder
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
    }
    return null;
  }

  // Yeni kullanıcı kaydı (Varsayılan olarak Kasiyer ve Onaysız başlar)
  Future<UserModel> signUp({required String email, required String password}) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    );
    final user = userCredential.user!;
    
    final userModel = UserModel(
      uid: user.uid,
      email: email,
      role: 'cashier', // Sisteme kayıt olan herkes önce kasiyer rolünü alır
      isApproved: false, // Admin paneli üzerinden onaylanması gerekir
    );

    // Kullanıcı modelini Firestore veritabanına yazıyoruz
    await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
    return userModel;
  }

  // Mevcut kullanıcı girişi
  Future<UserModel> signIn({required String email, required String password}) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password,
    );
    final doc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
    
    if (!doc.exists) {
      throw Exception("Kullanıcı veritabanında bulunamadı.");
    }
    return UserModel.fromMap(doc.data()!, doc.id);
  }
  
  // Çıkış yapma
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}