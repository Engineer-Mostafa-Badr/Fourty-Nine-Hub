import 'package:flutter/foundation.dart';

T pr<T>(T object) {
  if (kDebugMode) {
    print(" < salama dev >  $object");
  }
  return object;
}
