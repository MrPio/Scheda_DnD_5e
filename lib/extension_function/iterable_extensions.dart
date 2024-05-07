import 'dart:math';

extension IterableIterableExtensions<T> on Iterable<Iterable<T>> {
  List<T> get flatten => [for (var sublist in this) ...sublist];
}
extension IterableExtensions<T> on Iterable<T> {
  T get random=>elementAt(Random().nextInt(length));
}
