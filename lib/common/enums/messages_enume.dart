
enum MessageEnum {
  text("text"),
  image("image"),
  audio("audio"),
  video("video"),
  gif("gif");
  const MessageEnum(this.value);
  final String value;
}

extension ConvertMessage on String {
  MessageEnum get toMessageEnum {
    switch (this) {
      case "text":
        return MessageEnum.text;
      case "image":
        return MessageEnum.image;
      case "audio":
        return MessageEnum.audio;
      case "video":
        return MessageEnum.video;
      case "gif":
        return MessageEnum.gif;
      default:
        return MessageEnum.text;
    }
  }
}


