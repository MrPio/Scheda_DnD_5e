# BACKLOG
- Character avatar image can be uploaded from the gallery

# TODO
- `MaxHP`:
  X Set MaxHP right after the character's creation
  - Update MaxHP after the new level
- `Inventory`:
  - edit custom item bottom sheet entry
  - Make sell in a separate page. Too many coins.
  - In inventory, non satisfied strength requirement should be handled graphically
- `Account`:
  - write change password method in AccountManager (requires logged user).
  - Uniform the popup widget 
  - Make sure the password constraints on the app match those on Firebase Auth
  - Add change username popup
  - Add logout logic
- `Maintainability`:
  - Password requirements and error logics need to be centralized. Right now, it is both in SignIn, SignUp and UserScreen

# DONE
  X In numeric input, accorpa anche i pulsanti +, - laterali, così pulisci un sacco di codice
  X Pages that are both screens and pages require cleaner code.
    X- Define 1 screen (with args in constructor) and 1 page (with Navigator args) separately.
    X The page returns the screen wrapped in a Scaffold
    X The header title should be centralized since it's a lot of code and is common between Dice, Enchantments and User
X Add custom inventory item page
X Inventory TAB mockup
