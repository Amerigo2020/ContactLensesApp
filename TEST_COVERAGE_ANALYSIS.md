# Test Coverage Analysis

## Current State

The project has **virtually no test coverage**. The only test file (`test/widget_test.dart`) contains the default Flutter counter app smoke test — it doesn't test any actual LensGuard functionality. Across 31 source files and ~5,100 lines of code, there are zero meaningful tests.

---

## Priority 1: Pure Logic (Unit Tests — No Mocking Required)

These files contain pure functions with no external dependencies. They are the easiest to test and the highest-value starting point.

### `lib/utils/validators.dart`

| What to test | Why |
|---|---|
| `Validators.email()` — null, empty, invalid formats, valid emails | Guards user registration/login; a regex bug silently lets bad data through |
| `Validators.password()` — null, empty, short, valid | Controls whether users can sign up |
| `Validators.strongPassword()` — missing uppercase, lowercase, digits, length < 8 | Enforces password policy; each branch needs a dedicated case |
| `Validators.required()` — null, empty, with/without custom `fieldName` | Used across every form in the app |
| `Validators.dropdown()` — null vs non-null values | Used in prescription/lens selection |
| `checkPasswordStrength()` — weak/medium/strong boundary conditions | Drives the password strength indicator UI |

### `lib/utils/date_utils.dart`

| What to test | Why |
|---|---|
| `daysBetween()` — same day, consecutive days, negative direction | Foundation for all wear-tracking math |
| `getReplacementDate()` — various durations | Determines when users are told to replace lenses |
| `shouldReplace()` — before, on, and after replacement date | Incorrect result = health risk for users |
| `daysRemaining()` — positive, zero, negative (overdue) | Displayed on the dashboard |
| `getWearProgress()` — 0%, 50%, 100%, overdue | Drives the progress bar widget |
| `isInWarningZone()` — at 79% vs 80% vs 100% | Controls warning UI visibility |
| `formatRelativeDate()` — today, yesterday, tomorrow, 3 days ago, 3 days from now, >7 days | User-facing text; edge cases around "today" boundary |

### `lib/models/lens_price_entry.dart`

| What to test | Why |
|---|---|
| `PriceEntry.fromMap()` — complete data, missing fields, null price | Parses Firestore documents; bad data shouldn't crash the app |
| `PriceEntry.toMap()` — round-trip consistency | Data integrity for writes |
| `LensPriceCatalog.getPriceForDiopter()` — match found, no match | Returns `null` on miss; callers depend on this |
| `LensPriceCatalog.getLowestPrice()` — single entry, multiple entries, empty list | Empty list returns `0.0` which may mislead users — test documents this behavior |

### `lib/models/user.dart`

| What to test | Why |
|---|---|
| `User.toMap()` — all fields populated, optional fields null | Ensures Firestore writes are correct |
| `User.copyWith()` — override individual fields, verify others unchanged | Used in `UserProvider.updatePrescription` |

---

## Priority 2: Business Logic (Provider Tests — Require Mocking)

Providers contain the app's core business logic. Testing them requires mocking `FirestoreService`, `FirebaseService`, `NotificationService`, and `SharedPreferences`.

### `lib/providers/user_provider.dart`

| What to test | Why |
|---|---|
| `hasCompletedOnboarding` — with all fields set, with partial fields, with null user | Controls whether user sees onboarding or dashboard |
| `getExpectedDuration()` — "daily", "14", "2-week", "30", "monthly", "weekly", unknown model | Incorrect mapping = wrong replacement schedule. The string-matching logic (`contains('daily')`, `contains('14')`, etc.) is fragile and each branch needs a test |
| `updatePrescription()` — success path and error path | Verify local state (`_currentUser`) is updated after Firestore write |
| `clearUser()` — verify `_currentUser` becomes null and listeners are notified | Called on sign-out; leaking user data across sessions is a bug |
| `getDaysWorn()` — currently always returns 0 because `_getStartDate()` returns null | This is a latent bug worth documenting in a test |

### `lib/providers/auth_provider.dart`

| What to test | Why |
|---|---|
| `signInWithEmail()` — success sets loading states correctly, failure sets `_error` and rethrows | Loading/error state drives UI (spinners, error banners) |
| `signUpWithEmail()` — creates user document in Firestore after auth | Missing Firestore doc = broken profile |
| `signInWithGoogle()` — new user creates doc, existing user doesn't overwrite | Data loss risk if existing user is overwritten |
| `signOut()` — clears `_userProfile` | Stale user data after sign-out is a privacy issue |
| `deleteAccount()` — clears both `_userProfile` and `_firebaseUser` | GDPR compliance path |

### `lib/providers/reminder_provider.dart`

| What to test | Why |
|---|---|
| `init()` — loads saved values from SharedPreferences, uses defaults when no saved values exist | App startup correctness |
| `toggleMorningReminder(true)` — schedules notification; `toggleMorningReminder(false)` — cancels it | Core feature; wrong notification ID = reminder never fires |
| `setMorningTime()` / `setEveningTime()` — saves to prefs and reschedules if enabled | Time change without reschedule = reminder fires at old time |
| `scheduleAllReminders()` — only schedules enabled reminders | Called after permission grant; scheduling disabled reminders would confuse users |

---

## Priority 3: Service Layer (Integration-Style Tests)

These require Firebase/notification mocks but test important data-access patterns.

### `lib/services/firestore_service.dart`

| What to test | Why |
|---|---|
| `getUser()` — document exists vs doesn't exist (throws) | Callers must handle the exception |
| `updateUserProfile()` — only sends non-null fields | Sending null fields would erase data |
| `getCurrentLensWearDuration()` — no start date returns `Duration.zero` | Null safety on fresh accounts |
| `getBestPriceForUser()` — catalog exists vs doesn't, diopter match vs no match | Null return must not crash price UI |
| `deleteUserAccount()` — verify Firestore document deletion | GDPR compliance |

### `lib/services/firebase_service.dart`

| What to test | Why |
|---|---|
| `signInWithGoogle()` — `googleUser == null` throws correctly | User cancels Google sign-in dialog |
| `deleteAccount()` — "requires-recent-login" error is caught and rethrown with user-friendly message | Users see a helpful error instead of a stack trace |
| `createUserDocument()` — applies FCM token via `copyWith` | Missing token = no push notifications |

---

## Priority 4: Widget Tests

Lower priority than logic tests, but important for screens with significant conditional rendering.

### High-value widget tests

| Screen | What to test |
|---|---|
| `dashboard_screen.dart` | Renders wear progress, shows warning state when lens is overdue |
| `wear_time_card.dart` | Displays correct days remaining, color changes in warning zone |
| `login_screen.dart` | Form validation triggers, error messages display, loading spinner shows during auth |
| `signup_screen.dart` | Password strength indicator updates, validation on all fields |
| `reminders_screen.dart` | Toggle switches reflect provider state, time picker updates |

### Lower-value widget tests

Onboarding screens, profile screens, and the custom widgets (`CustomButton`, `CustomCard`, `EmptyState`) are simpler and less likely to harbor bugs. Test these after the above are covered.

---

## Specific Bugs and Risks Uncovered During Analysis

1. **`UserProvider.getDaysWorn()` always returns 0** — `_getStartDate()` is hardcoded to return `null` (`user_provider.dart:147-152`). Either the method is dead code or it's a bug. A test should document and assert this.

2. **`LensPriceCatalog.getLowestPrice()` returns `0.0` for empty lists** (`lens_price_entry.dart:84-87`) — This could display "$0.00" in the UI, misleading users into thinking lenses are free. A test should capture this edge case.

3. **`UserProvider.getExpectedDuration()` string matching is fragile** (`user_provider.dart:131-144`) — A lens model like "Acuvue Oasys for Astigmatism" won't match any pattern and silently defaults to 30 days. If a model name contains "daily" in a brand name but is actually monthly, it would return 1.

4. **The existing `widget_test.dart` tests a counter app that doesn't exist** — It will fail if run because `MyApp` doesn't have a counter. This test should be replaced entirely.

---

## Recommended Test File Structure

```
test/
  utils/
    validators_test.dart
    date_utils_test.dart
  models/
    user_test.dart
    lens_price_entry_test.dart
  providers/
    auth_provider_test.dart
    user_provider_test.dart
    reminder_provider_test.dart
  services/
    firestore_service_test.dart
    firebase_service_test.dart
  widgets/
    wear_time_card_test.dart
    dashboard_screen_test.dart
    login_screen_test.dart
```

## Suggested Testing Dependencies

Add to `dev_dependencies` in `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
  fake_cloud_firestore: ^3.1.0
  firebase_auth_mocks: ^0.14.1
  shared_preferences: ^2.2.2  # provides SharedPreferences.setMockInitialValues
```

## Summary

| Priority | Category | Files to test | Effort | Impact |
|---|---|---|---|---|
| **P1** | Pure logic | validators, date_utils, models | Low | High — catches data bugs with no mocking overhead |
| **P2** | Providers | auth, user, reminder providers | Medium | High — covers business logic and state transitions |
| **P3** | Services | firestore, firebase services | Medium | Medium — ensures data layer contracts hold |
| **P4** | Widgets | dashboard, login, signup, wear card | High | Medium — catches rendering regressions |
