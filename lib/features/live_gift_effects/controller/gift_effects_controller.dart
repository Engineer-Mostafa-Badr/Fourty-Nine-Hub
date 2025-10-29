import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/gift_effect.dart';

class GiftEffectsController extends ChangeNotifier {
  final QueueList<GiftEffect> _queue = QueueList();
  GiftEffect? _current;
  bool _isPlaying = false;

  GiftEffect? get current => _current;
  bool get isPlaying => _isPlaying;
  bool get hasQueue => _queue.isNotEmpty;

  void enqueue(GiftEffect effect) {
    _queue.add(effect);
    _tryPlayNext();
  }

  void enqueueAll(Iterable<GiftEffect> effects) {
    _queue.addAll(effects);
    _tryPlayNext();
  }

  void clear() {
    _queue.clear();
    _current = null;
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> _tryPlayNext() async {
    if (_isPlaying) return;
    if (_queue.isEmpty) return;

    _isPlaying = true;
    while (_queue.isNotEmpty) {
      _current = _queue.removeFirst();
      notifyListeners();
      final int repeats = _current!.repeatCount <= 0 ? 1 : _current!.repeatCount;
      for (int i = 0; i < repeats; i++) {
        await Future<void>.delayed(_current!.duration);
      }
      _current = null;
      notifyListeners();
      // Small gap between effects for UX
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }
    _isPlaying = false;
  }
}

/// Minimal queue list to avoid adding external dependencies for a deque.
class QueueList<T> {
  final List<T> _items = <T>[];

  void add(T value) => _items.add(value);
  void addAll(Iterable<T> values) => _items.addAll(values);
  T removeFirst() => _items.removeAt(0);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
  void clear() => _items.clear();
}



