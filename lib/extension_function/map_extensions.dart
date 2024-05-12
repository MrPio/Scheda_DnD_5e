

extension MapExtensions<K, V extends num> on Map<K, V> {
  // {a:1, b:2} + {a:1, c:1} = {a:2, b:2, c:1}
  Map<K, V> operator +(Map<K, V> other) =>
      map((key, value) => MapEntry(key, value + (other[key] ?? 0) as V))
        ..addEntries(other.entries.where((e) => !containsKey(e.key)));
  // {a:1, b:2} - {b:2, c:1} = {a:1}
  Map<K, V> operator -(Map<K, V> other) =>
      map((key, value) => MapEntry(key, value - (other[key] ?? 0) as V))
        ..removeWhere((key, value) => value<=0);
}
