import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

enum ChatCategories {
  social,
  service,
  socialCalls,
  serviceCalls,
  greet,
  groups,
  anonymous,
  locked,
  unread,
  archived,
  broadcast,
}

extension ChatCategoriesExtension on ChatCategories {
  String get name {
    switch (this) {
      case ChatCategories.social:
        return LocaleKeys.social;
      case ChatCategories.service:
        return LocaleKeys.services;
      case ChatCategories.socialCalls:
        return LocaleKeys.socialCalls;
      case ChatCategories.serviceCalls:
        return LocaleKeys.servicesCalls;
      case ChatCategories.greet:
        return LocaleKeys.greet;
      case ChatCategories.groups:
        return LocaleKeys.groups;
      case ChatCategories.anonymous:
        return LocaleKeys.anonymous;
      case ChatCategories.locked:
        return LocaleKeys.lockChat;
      case ChatCategories.unread:
        return LocaleKeys.unread;
      case ChatCategories.archived:
        return LocaleKeys.archive;
      case ChatCategories.broadcast:
        return LocaleKeys.broadcast;
    }
  }
}
