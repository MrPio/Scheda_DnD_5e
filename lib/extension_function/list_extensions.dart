extension ListExtensions on List {
  List toggle(element) {
    contains(element) ? remove(element) : add(element);
    return this;
  }

  List slice([int start = 0, int? end]) {
    int effectiveEnd = (end ?? length).clamp(-length, length);
    return sublist(start.clamp(0, length), effectiveEnd + (effectiveEnd < 0 ? length : 0));
  }
}

extension ListNumExtensions<T extends num> on List<T> {
  T sum() => reduce((value, element) => value + element as T);
}
