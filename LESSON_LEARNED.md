# Lessons learned

<a name="index"></a>
## 📘 Table of Contents
* [View components taxonomy](#ll4)
* [Pass arguments to a page](#ll3)
* [Java and Gradle Compatibility](#ll2)
* [Use `[]` initialization when the list is involved in a generic usage](#ll1)

<a name="ll4"></a>
## View components taxonomy
- `page`: A widget wrapped with a `Material`. Note that `Scaffold` implicitly defines it.
- `screen`: A collection of widgets defining the content of a page or a portion of it. Does not define a parent `Material`, thus, must be inside a page.
- `partial`: A customizable widget or layout that is reused throughout the application. Specialize Flutter's built-in components to the needs of the application. **Minimize the client's freedom** in the parameters.

<a name="ll3"></a>
## Pass arguments to a page

### Problem
When calling a polymorphous page, how should I pass my arguments?

### Solution

I can come up with two strategies. In both case it's best to wrap our arguments in a dedicate class.
#### Navigator's arguments
As in [Flutter Doc](https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments), one way is to rely on `Navigator`'s raw form of dependency injection.
```dart
ValueNotifier<Args?> args = ValueNotifier(null);

// build()
args.value ??= (ModalRoute.of(context)!.settings.arguments) as Args?;

// initState()
args.addListener(() {
  // Required to ensure that the widgets are built (may not be needed)
   WidgetsBinding.instance.addPostFrameCallback((_) {
     // Any initialization that needs to know the value of the args
   });
});
```
The advantage is a **loosely coupled** binding between the caller and the page.

Note: if you split the polymorphous widget into page + screen, the page receives the args from the Navigator and passes them to the screen constructor. This way the ValueNotifier<> wrapper can be removed and the screen code becomes:
```dart
final Args? args;

// initState()
WidgetsBinding.instance.addPostFrameCallback((_) {
 // Any initialization that needs to know the value of the args
});
```

#### Using the constructor
This approach **ties** the navigation logic with the page's constructor. It should be used only on `partial`s and `screen`s.


<a name="ll2"></a>
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

<a name="ll1"></a>
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

