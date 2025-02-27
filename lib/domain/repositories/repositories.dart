import '../entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity?> signUp(String email, String password, String role);
  Future<UserEntity?> signIn(String email, String password);
  Future<void> signOut();
  Future<String?> getUserRole(String uid);
  
}
