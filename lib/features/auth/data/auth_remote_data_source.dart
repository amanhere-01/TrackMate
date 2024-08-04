import 'package:firebase_auth/firebase_auth.dart';


abstract interface class AuthRemoteDataSource{

  User? get currentUser;

  Future signUp({
    required String name,
    required String email,
    required String password
  });

  Future signIn({
    required String email,
    required String password
  });

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  final _firebase = FirebaseAuth.instance;

  @override
  User? get currentUser => _firebase.currentUser;

  @override
  Future signUp({required String name, required String email, required String password}) async{
    try{
      await _firebase.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){
      if(e.code == 'email-already-in-use'){
        throw Exception(e.toString());
      }
    } catch(e){
      throw Exception(e.toString());
    }
  }

  @override
  Future signIn({required String email, required String password}) async{
    try{
      final user = await _firebase.signInWithEmailAndPassword(email: email, password: password);
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

}
