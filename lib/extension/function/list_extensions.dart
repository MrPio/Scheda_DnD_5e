extension ListExtensions on List {
  List toggle(element) {
    if (contains(element))
      remove(element);
    else
      add(element);
    return this;
  }
}

extension ListNumExtensions<T extends num> on List<T> {
  T sum() => reduce((value, element) => value + element as T);
}
