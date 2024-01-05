
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}



Future<File?> pickImage(BuildContext context) async {
File? image ;
try{
final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
if (pickedFile != null) {
  image = File(pickedFile.path);
}

return image;

}catch(e) {
  print(e);
  showSnackBar(context, e.toString());
  return null;
}

}