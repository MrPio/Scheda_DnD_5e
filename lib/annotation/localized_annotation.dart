class Localized {
  final List<String> fields;

  /// Generate the code to dynamically load the String [fields] from AppLocalizations based on the locale of the context.
  const Localized(this.fields);
}