# Feature: Fix Firebase Windows Configuration

> Erstellt: 2026-01-25
> Status: 🟡 In Planung

## Ziel
Die App soll auf Windows lauffähig sein, indem die fehlende Firebase-Konfiguration für Windows hinzugefügt wird.

## Anforderungen
- [ ] `lib/firebase_options.dart` muss eine gültige Konfiguration für `TargetPlatform.windows` enthalten.
- [ ] Die App muss auf Windows ohne `Unsupported operation: DefaultFirebaseOptions have not been configured for windows` Absturz starten.

## Scope
**In Scope:**
- Konfiguration von Firebase für Windows.
- Update von `lib/firebase_options.dart`.

**Out of Scope:**
- Einrichtung von Firebase-Projekten (wird vorausgesetzt).
- Andere Plattform-Fehler (sofern nicht direkt verbunden).

## Technischer Ansatz
1.  Identifizieren der fehlenden API-Schlüssel und App-IDs für Windows.
2.  Entweder durch `flutterfire configure` CLI (vom User auszuführen) oder manuelles Hinzufügen der Keys, falls der User diese bereitstellt.
3.  Anpassung der `DefaultFirebaseOptions`-Klasse.

## Betroffene Dateien
- `lib/firebase_options.dart`

## Abhängigkeiten
- [ ] Zugriff auf Firebase Console oder FlutterFire CLI Setup.

## Offene Fragen
- [ ] Hat der User die Windows-App bereits im Firebase-Projekt registriert?
- [ ] Sind die Keys für Android/iOS im Code aktuell nur Platzhalter ('YOUR_API_KEY')? Wenn ja, müssen diese auch gefixt werden?
