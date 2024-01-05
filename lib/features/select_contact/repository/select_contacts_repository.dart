import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final selectContactsRepositoryProvider =
    Provider<SelectContactsRepository>((ref) {
  return SelectContactsRepository(
      firebaseFirestore: FirebaseFirestore.instance);
});

class SelectContactsRepository {
  final FirebaseFirestore firebaseFirestore;

  SelectContactsRepository({required this.firebaseFirestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(context, {required Contact contact}) async {
    try {
      var userCollection = await firebaseFirestore.collection('users').get();
      bool isUserExist = false;
UserModel userData= UserModel();
      for (var user in userCollection.docs) {


        if (user.data()['phone'] ==
            contact.phones.first.number.toString().replaceAll(' ', '')) {
          userData = UserModel.fromJson(user.data()) ;
          isUserExist = true;
        }
      }
      if (isUserExist) {
        Navigator.pushReplacementNamed(context, '/mobile-chat-screen',arguments:
        {
         "name":userData.name,
          "profileImage":userData.profileImage,
          "phone":userData.phone,
          "uid":userData.uid,
        });
      } else {
        showSnackBar(context, 'User not found');
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }
}
