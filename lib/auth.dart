import 'package:Donate/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Donate/CustomUser.dart';

class AuthService{
  final FirebaseAuth _auth=FirebaseAuth.instance;

  CustomUser _createUser(User user){
    if (user!=null) {
      return CustomUser(userId: user.uid);
    } else {
      return null;
    }
  }

  Stream<CustomUser> get user {
    return _auth.authStateChanges()
        .map(_createUser);
  }

  Future signInWithEmailAndPassword(String email,String password) async {
    try{
      User user=(await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
      return _createUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email,String password, String name,String phone,String userType, String address) async {
    try{
      User user=(await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
      await DatabaseService(uid: user.uid).updateUserData(name, email, userType, phone, address);

      return _createUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signout() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}