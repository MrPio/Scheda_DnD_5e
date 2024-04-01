import 'dart:core' hide Comparable;
import 'dart:core' as core show Comparable;

mixin  Comparable<T> implements core.Comparable<T> {
  bool operator <=(T other) => compareTo(other) <= 0;

  bool operator >=(T other) => compareTo(other) >= 0;

  bool operator <(T other) => compareTo(other) < 0;

  bool operator >(T other) => compareTo(other) > 0;

  bool operator ==(other) => other is T && compareTo(other as T) == 0;
}
