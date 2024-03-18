import "package:firebase_auth/firebase_auth.dart";



class Auth{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? currentUser ()=> firebaseAuth.currentUser;
  Stream<User?> authState ()=>firebaseAuth.authStateChanges();


  Future<UserCredential> registration({required String email, required String password})async{
    return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> login({required String email, required String password})async{
    await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout()async{
    await firebaseAuth.signOut();
  }






}


