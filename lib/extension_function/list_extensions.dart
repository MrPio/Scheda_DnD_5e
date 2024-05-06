extension ListExtensions on List {
  List toggle(element) {
    contains(element) ? remove(element) : add(element);
    return this;
  }
}

extension ListNumExtensions<T extends num> on List<T> {
  T sum() => reduce((value, element) => value + element as T);
}
