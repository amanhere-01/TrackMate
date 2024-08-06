import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:track_mate/core/models/user.dart';

abstract interface class AuthRemoteDataSource{

  fb.User? get currentUser;

  Future<User> signUp({
    required String name,
    required String email,
    required String password
  });

  Future<User> signIn({
    required String email,
    required String password
  });
  
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  final _firebase = fb.FirebaseAuth.instance;

  @override
  fb.User? get currentUser => _firebase.currentUser;

  @override
  Future<User> signUp({required String name, required String email, required String password}) async{
    try{
      final res = await _firebase.createUserWithEmailAndPassword(email: email, password: password);
      await res.user?.updateDisplayName(name);
      if(res.user != null){
        throw Exception('Sign-up failed: User is null. ');
      }
      return User(uid: res.user!.uid, name: res.user!.displayName ?? name, email: res.user!.email!);
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('The email address is already in use by another account.');
      } else {
        throw Exception(e.toString());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<User> signIn({required String email, required String password}) async{
    try{
      final res = await _firebase.signInWithEmailAndPassword(email: email, password: password);
      return User(uid: res.user!.uid, name: res.user!.displayName!, email: res.user!.email!);
    } on fb.FirebaseAuthException catch(e){
      throw Exception(e.toString());
    } catch(e){
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async{
    try{
      await _firebase.signOut();
    } on fb.FirebaseAuthException catch(e){
      throw Exception(e.toString());
    } catch(e){
      throw Exception(e.toString());
    }
  }

}
