enum MessageTypeEnum {
  text,
  media,
  video,
  location,
  contact,
  system;

  static MessageTypeEnum fromString(String value) {
    switch (value) {
      case 'text':
        return MessageTypeEnum.text;
      case 'media':
        return MessageTypeEnum.media;
      case 'video':
        return MessageTypeEnum.video;
      case 'location':
        return MessageTypeEnum.location;
      case 'contact':
        return MessageTypeEnum.contact;
      case 'system':
        return MessageTypeEnum.system;
      default:
        return MessageTypeEnum.text;
    }
  }
}