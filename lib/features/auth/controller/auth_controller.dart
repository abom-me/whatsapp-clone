
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_repository.dart';

import '../../../models/user_model.dart';


final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(
    ref: ref,
    authRepository: ref.watch(authRepositoryProvider),
  );
});

final userDataAuthProvider = FutureProvider((ref) {

  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUser();
});
class AuthController{
  final AuthRepository authRepository;
final ProviderRef ref ;
  AuthController(  {required this.ref,required this.authRepository});

  void signInWithPhoneNumber(BuildContext context,String phone){
    authRepository.signInWithPhoneNumber(context,phone);
  }

  void setUserState(bool isOnline){
    authRepository.setUserState( isOnline: isOnline);
  }

  void verifyOTP( BuildContext context,String verificationId,String smsCode,){
    authRepository.verifyOTP(context,verificationId,smsCode);
  }


  void saveUserDataToFirebase(BuildContext context, String name, File? profileImage){
    authRepository.saveUserDataToFirebase(name: name, profileImage: profileImage, ref: ref, context: context);

  }
  
  
  Future<UserModel?> getCurrentUser() async {
    return await authRepository.getCurrentUser();
  }


  Stream<UserModel> userDataById(String uid){
    return authRepository.userData(uid);
  }

  Future<UserModel> getUserDetails(String uid){
    return authRepository.userDetails(uid);
  }
}