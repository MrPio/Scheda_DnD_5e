## Use `[]` initialization when the list is involved in a generic usage

When working with generics, it may become tricky to handle the assignment to lists.

### Problem

```dart

List<Character>? cachedCharacters = null;
List<Enchantment>? cachedEnchantments = null;

Map<core.Type, List<WithUID>> get caches =>
    {
      Character: cachedCharacters,
      Enchantment: cachedEnchantments,
    };
```

In this scenario, assigning the empty list is no easy task if we access the variable
through `caches`, where the supertype is `WithUID`.
This is because, in an instruction like `cache[Chracter]! = []` we try to assign `List<WithUID>`
to `List<Chracter>`.

### Solution

```dart
List<InventoryItem> cachedInventoryItems = [];
```
## Java and Gradle Compatibility

### Problem

Application fails to launch due to incompatibility between Java and Gradle version.

### Solution

1) Check versions according to [Compatibility Matrix](https://docs.gradle.org/current/userguide/compatibility.html#javam)
    * Determine Gradle version by checking the distributionUrl in the *android/gradle/wrapper/gradle-wrapper.properties* file.
    * Verify Java version by running *java -version* in terminal.
2) If Java version is incompatible, change it with:
```shell
flutter config --jdk-dir <path_to_jdk>
```
3) Recreate Project (if Gradle and Java versions are compatible)
   * Delete the android folder.
   * Recreate the project using:
```shell
flutter create --project-name scheda_dnd_5e .
```

Note: JDK version is your degree of freedom, flutter manages its own version of Gradle.