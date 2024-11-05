import 'dart:core' hide Comparable;
import 'dart:core' as core show Comparable;

/// Implement custom sorting policy for the model classes
mixin  Comparable<T> implements core.Comparable<T> {
  bool operator <=(T other) => compareTo(other) <= 0;

  bool operator >=(T other) => compareTo(other) >= 0;

  bool operator <(T other) => compareTo(other) < 0;

  bool operator >(T other) => compareTo(other) > 0;

  @override
  bool operator ==(other) => other is T && compareTo(other as T) == 0;
}
