import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/auth_remote_data_source.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteDataSource _authRemoteDataSource;
  AuthBloc(this._authRemoteDataSource) : super(AuthInitial()) {

    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthSignOut>(_onAuthSignOut);
  }

  Future<void> _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    try{
      await _authRemoteDataSource.signUp(name: event.name, email: event.email, password: event.password);
      emit(AuthSuccess());
    } catch(e){
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async{
    try{
      await _authRemoteDataSource.signIn(email: event.email, password: event.password);
      emit(AuthSuccess());
    } catch(e){
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    try{
      await _authRemoteDataSource.signOut();
      emit(AuthSuccess());
    } catch(e){
      emit(AuthFailure(e.toString()));
    }
  }

}
