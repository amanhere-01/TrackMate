import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:track_mate/core/models/user_model.dart';

abstract interface class AuthRemoteDataSource{

  UserModel getCurrentUserModel();

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password
  });

  Future<UserModel> signIn({
    required String email,
    required String password
  });
  
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  final _firebase = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  @override
  UserModel getCurrentUserModel() {
    final user = _firebase.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email!,
    );
  }

  @override
  Future<UserModel> signUp({required String name, required String email, required String password}) async{
    try{
      final res = await _firebase.createUserWithEmailAndPassword(email: email, password: password);
      await res.user?.updateDisplayName(name);
      if(res.user == null){
        throw Exception('Sign-up failed: User is null. ');
      }
      await storeUserData(uid: res.user!.uid, name: name, email: email);
      return UserModel.fromDatabase(res.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('The email address is already in use.');
      } else {
        throw Exception(e.toString());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> signIn({required String email, required String password}) async{
    try{
      final res = await _firebase.signInWithEmailAndPassword(email: email, password: password);
      return UserModel.fromDatabase(res.user!);
    } on FirebaseAuthException catch(e){
      throw Exception(e.toString());
    } catch(e){
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async{
    try{
      await _firebase.signOut();
    } on FirebaseAuthException catch(e){
      throw Exception(e.toString());
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<void> storeUserData({
      required String uid,
      required String name,
      required String email
  }) async{
    try{
      final docRef = db.collection('user_data').doc(uid);
      await docRef.set({
        'name': name,
        'email': email,
        'uid': uid,
      });
    } catch(e){
      throw Exception('Failed to store user data: $e');
    }
  }


}
