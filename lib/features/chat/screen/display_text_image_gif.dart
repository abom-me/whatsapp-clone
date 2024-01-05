import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../common/enums/messages_enume.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({super.key,required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return type.value =="text"?Text(
      message,
      style: const TextStyle(
        fontSize: 16,
      ),
    ):CachedNetworkImage(
      imageUrl: message,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
