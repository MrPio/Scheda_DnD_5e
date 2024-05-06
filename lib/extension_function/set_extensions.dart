extension SetExtensions<T> on Set<T> {
  Set toggle(element) {
    contains(element) ? remove(element) : add(element);
    return this;
  }
  Set<T> operator +(Set<T> other)=>Set.from(this)..addAll(other);
  Set<T> operator -(Set<T> other)=>Set.from(this)..removeAll(other);
}

extension SetNumExtensions<T extends num> on Set<T> {
  T sum() => reduce((value, element) => value + element as T);
}
