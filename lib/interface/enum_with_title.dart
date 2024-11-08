abstract class EnumWithTitle implements Enum,WithTitle {
  @override
  final String title = '';
}

abstract class WithTitle {
  final String title = '';
}
