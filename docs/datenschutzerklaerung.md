# Datenschutzerklärung — LensGuard

Stand: [PLATZHALTER: Datum der Veröffentlichung]

## 1. Verantwortlicher

[PLATZHALTER: Vor- und Nachname]
[PLATZHALTER: Straße, Hausnummer]
[PLATZHALTER: PLZ, Ort, Land]
E-Mail: [PLATZHALTER: Kontakt-E-Mail]

## 2. Überblick

LensGuard ist eine App für Kontaktlinsenträger. Sie bietet Tragezeit-Tracking,
Wechsel-Erinnerungen, Preisbenachrichtigungen und die Speicherung Ihres
Sehstärken-Profils. Zur Bereitstellung dieser Funktionen verarbeiten wir die
nachfolgend beschriebenen Daten.

## 3. Verarbeitete Daten und Zwecke

### 3.1 Konto und Anmeldung (Firebase Authentication, Google Sign-In)
- **Daten:** E-Mail-Adresse, Passwort (verschlüsselt gespeichert bei Google),
  bei Google-Anmeldung: Google-Konto-Kennung und Profilinformationen
- **Zweck:** Erstellung und Verwaltung Ihres Nutzerkontos
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. b DSGVO (Vertragserfüllung)

### 3.2 Gesundheitsdaten — Sehstärke (Cloud Firestore)
- **Daten:** Dioptrien-Werte (links/rechts), bevorzugte Linsenmarke und -modell,
  Startdatum des aktuellen Linsenpaars
- **Zweck:** Kernfunktion der App (Tragezeit-Tracking, passende Preisanzeige)
- **Rechtsgrundlage:** Art. 9 Abs. 2 lit. a DSGVO (ausdrückliche Einwilligung).
  Sie können diese Einwilligung jederzeit durch Löschung Ihres Kontos widerrufen.

### 3.3 Push-Benachrichtigungen (Firebase Cloud Messaging)
- **Daten:** Geräte-Token (FCM-Token)
- **Zweck:** Zustellung von Preisalarmen
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. a DSGVO (Einwilligung über die
  Benachrichtigungsberechtigung des Betriebssystems)

### 3.4 Lokale Erinnerungen
Wechsel- und Tageserinnerungen werden ausschließlich lokal auf Ihrem Gerät
geplant und gespeichert. Es findet keine Übertragung an Server statt.

### 3.5 Absturzberichte (Firebase Crashlytics)
- **Daten:** Absturzprotokolle, Stacktraces, Gerätemodell, Betriebssystemversion
- **Zweck:** Erkennung und Behebung von Fehlern
- **Rechtsgrundlage:** Art. 6 Abs. 1 lit. f DSGVO (berechtigtes Interesse an
  einer stabilen App)

### 3.6 Nutzungsanalyse und Performance (Firebase Analytics, Firebase Performance Monitoring)
- **Daten:** App-Interaktionen, Sitzungsdauer, Geräteinformationen,
  ungefährer Standort (auf Länder-/Regionsebene), App-Instanz-ID,
  Ladezeiten und Netzwerk-Latenzen
- **Zweck:** Verbesserung der App
- **Rechtsgrundlage:** [PLATZHALTER: Einwilligung nach Art. 6 Abs. 1 lit. a
  DSGVO — HINWEIS: Aktuell ist Analytics ohne Consent-Dialog aktiviert.
  Vor EU-Release Consent-Flow einbauen oder Analytics deaktivieren.]

## 4. Empfänger und Drittlandübermittlung

Alle genannten Dienste werden von Google Ireland Ltd. (Gordon House, Barrow
Street, Dublin 4, Irland) als Auftragsverarbeiter betrieben. Dabei können Daten
in die USA an Google LLC übertragen werden. Google ist unter dem EU-US Data
Privacy Framework zertifiziert; die Übermittlung erfolgt auf dieser Grundlage
sowie auf Basis von Standardvertragsklauseln.

Firestore-Speicherort: [PLATZHALTER: Region in der Firebase Console prüfen,
z. B. europe-west3 (Frankfurt)]

## 5. Speicherdauer

Ihre Daten werden gespeichert, solange Ihr Konto besteht. Bei Löschung Ihres
Kontos werden Ihre Profildaten und Ihr Authentifizierungskonto unverzüglich
gelöscht. Crashlytics-Daten werden von Google nach 90 Tagen, Analytics-Daten
nach [PLATZHALTER: eingestellte Aufbewahrungsdauer, Standard 14 Monate]
automatisch gelöscht.

## 6. Ihre Rechte

Sie haben das Recht auf Auskunft (Art. 15), Berichtigung (Art. 16), Löschung
(Art. 17), Einschränkung der Verarbeitung (Art. 18), Datenübertragbarkeit
(Art. 20) und Widerspruch (Art. 21 DSGVO). Sie können sich zudem bei einer
Datenschutzaufsichtsbehörde beschweren.

## 7. Kontolöschung

Sie können Ihr Konto einschließlich aller gespeicherten Daten direkt in der
App löschen: Profil → [PLATZHALTER: genauer Menüpfad zur Kontolöschung].
Alternativ senden Sie eine Löschanfrage an [PLATZHALTER: Kontakt-E-Mail].

## 8. Kinder

Die App richtet sich nicht an Kinder unter 16 Jahren.

## 9. Änderungen

Wir können diese Datenschutzerklärung anpassen. Die aktuelle Fassung ist
stets unter [PLATZHALTER: öffentliche URL der Datenschutzerklärung] abrufbar.
