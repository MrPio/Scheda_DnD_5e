# Lessons learned

<a name="index"></a>
## 📘 Table of Contents
* [Emulator is unbearably glitchy](#ll7)
* [Undo Github commits](#ll6)
* [Git mismatching line ending causes huge commits](#ll5)
* [View components taxonomy](#ll4)
* [Pass arguments to a page](#ll3)
* [Java and Gradle Compatibility](#ll2)
* [Use `[]` initialization when the list is involved in a generic usage](#ll1)

<a name="ll7"></a>
## Emulator is unbearably glitchy

### Problem
When GPU is in use (`host` mode) the emulator is faster, but more glitchy, the app crashes often and screen sometimes freezes, preventing alert dialogs from showing.

### Solution
`Device Manager` --> `3 dots` --> `Show on Disk` --> open `config.ini` --> edit `hw.gpu.mode` from `host` to `guest` to disable GPU optimization --> `Stop` and run device with `Cold boot`.

As it's always the case, CPU is slower but safer when it comes to emulation.


<a name="ll6"></a>
## Undo Github commits

### Problem
Sometimes you need to remove the latest commits from Github. This happens, for example, in the case of a large `merge` operation caused by a forgotten `fetch' before committed changes.

### Solution
From the terminal, launch the following commands:
1. `git reset --soft <COMMIT_HASH>` where `COMMIT_HASH` is the SHA of the commit you can retrieve from Github or through the `git rev-list HEAD` command.
   * `--soft` is used to move the `HEAD` position updating the *index*, but not the *working tree*, i.e. the local files.
   * `--hard` is used to move the `HEAD` position updating the *index* and the *working tree*.
2. `git add .` & `git commit -m <MSG>` to commit the *working tree*.
3. `git push origin <BRANCH> --force` to overwrite all the commits happened after the `COMMIT_HASH`.

<a name="ll5"></a>
## Git mismatching line ending causes huge commits

### Problem
When committing from Linux, git forced me to rewrite all the files in the project, even those without any changes by my side.

### Solution
This is due to the value of the `core.autocrlf` git variable, which may be different between my Windows and Linux installations. This cause git to overwrite the LF with CRLF.
The solution is to write `* text=auto` in the `.gitattributes` file in the root of the project.

Read more [here](https://stackoverflow.com/a/38017715/19815002).


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

