
extension ListExtensions on List {
  List toggle(element) {
    if (contains(element))
      remove(element);
    else
      add(element);
    return this;
  }
}
