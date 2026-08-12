# Store-Angaben — LensGuard

Antworten für die Pflichtformulare in Google Play Console und App Store Connect.
Quelle: Code-Analyse vom 2026-07-12 (Firebase Auth, Firestore, FCM, Crashlytics,
Analytics, Performance, Google Sign-In; keine Ads-SDKs, kein Standortzugriff).

## Google Play — Data Safety (Datensicherheit)

**Erhebt oder teilt Ihre App Nutzerdaten?** Ja (erhoben, nicht "geteilt" im
Play-Sinne — Google/Firebase ist Auftragsverarbeiter).

| Kategorie | Datentyp | Erhoben | Zweck | Optional? |
|---|---|---|---|---|
| Persönliche Infos | E-Mail-Adresse | Ja | Kontoverwaltung | Nein |
| Persönliche Infos | Nutzer-IDs | Ja | Kontoverwaltung | Nein |
| Gesundheit & Fitness | Gesundheitsinfos (Dioptrien) | Ja | App-Funktionalität | Nein |
| App-Aktivität | App-Interaktionen | Ja | Analyse | Nein* |
| App-Info & Leistung | Absturzprotokolle | Ja | Analyse | Nein* |
| App-Info & Leistung | Diagnose/Performance | Ja | Analyse | Nein* |
| Geräte-IDs | Geräte- oder andere IDs (FCM-Token, App-Instanz-ID) | Ja | App-Funktionalität, Analyse | Nein |

\* Wird "nicht optional", solange kein Consent-/Opt-out-Dialog existiert.

- Daten bei Übertragung verschlüsselt: **Ja** (TLS)
- Nutzer können Löschung beantragen: **Ja** (In-App-Kontolöschung)
- Kontolöschungs-URL (Pflichtfeld): [PLATZHALTER: URL einer Webseite mit
  Löschanleitung, z. B. GitHub Pages]
- Datenschutzerklärungs-URL (Pflichtfeld): [PLATZHALTER: öffentliche URL]

**Weitere Play-Console-Pflichten:** Content-Rating-Fragebogen (keine bedenklichen
Inhalte → "Alle Altersgruppen"-Einstufung erwartbar), Zielgruppe nicht "Kinder",
Kategorie: Medizin oder Gesundheit & Fitness, App-Zugriff: Testkonto für die
Prüfung angeben (Login erforderlich!): [PLATZHALTER: Test-E-Mail + Passwort].

## Apple — App Privacy (Nutrition Label)

**Data Linked to You** (mit Konto verknüpft):
- Contact Info → Email Address (App Functionality)
- Health & Fitness → Health (Dioptrien-Werte) (App Functionality)
- Identifiers → User ID, Device ID (App Functionality, Analytics)
- Usage Data → Product Interaction (Analytics)
- Diagnostics → Crash Data, Performance Data (App Functionality, Analytics)

**Data Used to Track You:** Keine (keine Werbe-SDKs, kein Cross-App-Tracking
→ kein ATT-Dialog nötig).

**Weitere App-Store-Connect-Pflichten:**
- Privacy-Policy-URL: [PLATZHALTER]
- Kontolöschung in der App: vorhanden (Apple-Pflicht seit 2022 erfüllt)
- Demo-Account für App Review: [PLATZHALTER: Test-E-Mail + Passwort]
- Kategorie: Medical oder Health & Fitness
- Altersfreigabe-Fragebogen: keine bedenklichen Inhalte → 4+

## Offene Punkte vor Einreichung

1. [ ] Datenschutzerklärung öffentlich hosten (URL in beide Stores)
2. [ ] Kontolöschungs-Seite hosten (Play-Pflicht)
3. [ ] Analytics-Consent klären: Opt-in-Dialog einbauen ODER
       `setAnalyticsCollectionEnabled(false)` als Default (DSGVO)
4. [ ] Screenshots (Play: min. 2 pro Formfaktor; Apple: 6.7" + 6.5" iPhone)
5. [ ] Kurz-/Langbeschreibung, Feature-Grafik (Play, 1024×500)
6. [ ] Play: 12 Tester × 14 Tage geschlossener Test (Pflicht für neue Privatkonten)
7. [ ] iOS: Apple Developer Account, Firebase-iOS-App + GoogleService-Info.plist,
       APNs-Key in Firebase hinterlegen, iOS-App-Icons
