import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/repositoris/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/mobile_layout_screen.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    firebaseAuth: FirebaseAuth.instance,
    firebaseFirestore: FirebaseFirestore.instance,
  );
});

class AuthRepository {
  final FirebaseAuth firebaseAuth;

  final FirebaseFirestore firebaseFirestore;

  AuthRepository({required this.firebaseAuth, required this.firebaseFirestore});

  void setUserState({ required bool isOnline})  async{
    var userState = firebaseFirestore.collection("users").doc(firebaseAuth.currentUser!.uid);
   await userState.update({"isOnline": isOnline});
  }


  void signInWithPhoneNumber(BuildContext context, String phone) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
          showSnackBar(context, "Verification Completed");
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          Navigator.pushNamed(context, '/otp', arguments: verificationId);
          showSnackBar(context, "Code Sent");
        },
        codeAutoRetrievalTimeout: (String verificationId) async {
          showSnackBar(context, "Time Out");
        },
      );
    } catch (e) {
      print(e);
      showSnackBar(context, e.toString());
    }
  }

  void verifyOTP(
      BuildContext context, String verificationId, String smsCode) async {
    try {
      firebaseAuth.signInWithCredential(PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode));
      showSnackBar(context, "Verification Completed");
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      print(e);
      showSnackBar(context, e.toString());
    }
  }

  saveUserDataToFirebase(
      {required String name,
      required File? profileImage,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      String imageUrl =
          "https://api.dicebear.com/7.x/lorelei-neutral/png?seed=Tiger";
      if (profileImage != null) {
        imageUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase("profilePic/$uid", profileImage);
      }
      var user= UserModel(uid: uid, name: name, profileImage: imageUrl, phone: firebaseAuth.currentUser!.phoneNumber!,isOnline: true);
     await firebaseFirestore.collection("users").doc(uid).set(user.toJson());
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>MobileLayoutScreen()), (route) => false);
    } catch (e) {
      print(e);
      showSnackBar(context, e.toString());
    }
  }

Future<UserModel?> getCurrentUser() async {
  try{
    String uid = firebaseAuth.currentUser!.uid;
    DocumentSnapshot documentSnapshot = await firebaseFirestore.collection("users").doc(uid).get();
    return UserModel.fromJson(documentSnapshot.data() as Map<String,dynamic>);
  }catch(e){
    print(e);
    return null;
  }

}


Stream<UserModel> userData(String userId)  {
return  firebaseFirestore.collection("users").doc(userId).snapshots().map((event) => UserModel.fromJson(event.data() as Map<String,dynamic>));
}
}
