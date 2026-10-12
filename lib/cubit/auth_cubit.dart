import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final _auth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_msg(e)));
    }catch(e){
      emit(AuthError('Error:$e'));
    }
  }

  Future<void> register(String name,String email, String password) async {
    emit(AuthLoading());
    try {
      final cred=await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      await cred.user?.updateDisplayName(name.trim());
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      print('Firebase error code: ${e.code}');
      print('Firebase error message: ${e.message}');
      emit(AuthError(_msg(e)));
    }
    catch (e) {
      print('Unexpected error: ${e.runtimeType}:$e');
      emit(AuthError('Error:$e'));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    emit(AuthInitial());
  }

  String _msg(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is wrong';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password is too weak (min 6 chars)';
      case 'invalid-email':
        return 'Invalid email';
      default:
        return e.message ?? 'Something went wrong';
    }
  }
}