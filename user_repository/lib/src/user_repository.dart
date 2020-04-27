abstract class UserRepository {
  // Future<bool> isAuthenticated();

  // Future<void> authenticate();


  Future<void> signInWithCredentials(String email, String password);

  Future<void> signOut();

  Future<bool> isSignedIn();
 
  Future<String> getUserId();
  
  Future<String> getUserEmail();
}