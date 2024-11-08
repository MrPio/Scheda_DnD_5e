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

> List<InventoryItem> cachedInventoryItems = [];