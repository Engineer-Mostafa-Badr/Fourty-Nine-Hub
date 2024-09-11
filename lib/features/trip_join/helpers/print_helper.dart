import 'package:flutter/foundation.dart';

T pr<T>(T object) {
  if (kDebugMode) {
    print(" < eslam dev >  $object");
  }
  return object;
}
