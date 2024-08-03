import 'package:firebase_auth/firebase_auth.dart';


abstract interface class AuthRemoteDataSource{

  Future signUp({
    required String name,
    required String email,
    required String password
  });

  Future signIn({
    required String email,
    required String password
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  @override
  Future signUp({required String name, required String email, required String password}) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
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
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){
      throw Exception(e.toString());
    } catch(e){
      throw Exception(e.toString());
    }
  }

}
