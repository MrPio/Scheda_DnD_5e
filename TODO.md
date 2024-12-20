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
  - Add friends logic
  - Uniformare doppi camel case
  - popup di password: uniformare i textfield e prova hrule
  - use `canPopPositiveCallback` to avoid popping the popup in case any error occurs when changing username/password
- `Friendship`:
  - Metodi per accettare/rifiutare in datamanager (non servono! Usa il metodo save())
  - Ricordati di runnare `dart run build_runner build` quando hai modificato/ creato model
  - Creare Realtime Manager
- `App Settings`:
  - Add settings menu logic
- `Maintainability`:
  - Password requirements and error logics need to be centralized. Right now, it is both in SignIn, SignUp and UserScreen
  - The width of the popups should not depend on the message
- `User Experience`:
  - After log-in, cache populating should be done with the loading view active. At this very moment the users stares at the signin screen for 5 seconds.

# DONE
X `Friendship`:
  X crea la classe `Friendship`
  X aggiungi gli oggetti di `Friendship` in cui lo user attuale è coinvolto nel suo oggetto, mettili una lista `friendships` **non serializzabile**
X Account 
  X Add bottom sheet for "password dimenticata" in change password button
  X Add logout logic
  X write change password method in AccountManager (requires current password).
  X Uniform the popup widget
  X Add change username popup
  X Make sure the password constraints on the app match those on Firebase Auth
X In numeric input, accorpa anche i pulsanti +, - laterali, così pulisci un sacco di codice
X Pages that are both screens and pages require cleaner code.
  X Define 1 screen (with args in constructor) and 1 page (with Navigator args) separately.
  X The page returns the screen wrapped in a Scaffold
  X The header title should be centralized since it's a lot of code and is common between Dice, Enchantments and User
X Add custom inventory item page
X Inventory TAB mockup
