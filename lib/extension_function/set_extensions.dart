extension SetExtensions<T> on Set<T> {
  Set toggle(element) {
    contains(element) ? remove(element) : add(element);
    return this;
  }
  Set<T> operator +(Set<T> other)=>{}..addAll(this)..addAll(other);
}

extension SetNumExtensions<T extends num> on Set<T> {
  T sum() => reduce((value, element) => value + element as T);
}
