# Hyperframes Composition Brief: LensGuard

## Objective
Create a short launch-style brag video for LensGuard — played as a sincere, overproduced "startup launch from 2020".

## Output
- Composition directory: `brag-output/composition/`
- Rendered video: `brag-output/brag.mp4`
- Format: landscape — 1920x1080
- Duration: 20.5 seconds

## Source Material
- Project root: `C:\Users\ameri\Documents\Programming\ContactLensesApp`
- Primary files read: `README.md`, `lib/main.dart` (theme + splash), `lib/features/dashboard/widgets/wear_time_card.dart`, `lib/features/dashboard/screens/dashboard_screen.dart`
- Product name: LensGuard
- Tagline / strongest claim: "Your Smart Contact Lens Assistant" (splash screen, verbatim)
- Key UI or visual moment to recreate: the wear-time card — circular progress ring with "Day 4 / of 14" centered, "14-Day" badge, days-remaining pill, "Start New Pair" button (wear_time_card.dart)
- Copy that must appear verbatim:
  - "Your Smart Contact Lens Assistant"
  - "Start New Pair"
  - "New lens pair started!"
  - "Time to replace your lenses!"

## Creative Direction
- Tone preset: app-store
- Creative direction: "Startup launch from 2020" (user-provided)
- Interpretation: earnest, clean feature-card launch video — soft blue gradients, title-case copy, one claim per scene, smooth slides/wipes, upbeat corporate bed. No irony in delivery; the era-accurate sincerity is the joke.
- Angle: a pitch-perfect 2020-era startup launch video whose Series-A production energy is aimed at remembering to change your contact lenses.
- Hook: "You forgot when you opened these lenses." → "Again."
- Outro / punchline: recreated splash screen (gradient + eye icon + LensGuard + tagline), then "Available now."
- Avoid:
  - Generic SaaS language
  - Abstract filler visuals
  - Unrelated visual redesign

## Visual Identity
- Background: #FFFFFF light scenes; hero/outro gradient #2196F3 → #1976D2
- Text: #1A1A1A on light; white on gradient
- Accent: #2196F3 (LensGuard Blue); orange #FF9800 warning; green #4CAF50 success; grey-200 ring track
- Display font: Roboto (heavy) — Flutter Material default; system fallback ok
- Body font: Roboto
- Visual references from the project: circular wear ring (12px stroke), Material 3 rounded cards (16px radius), pill badges (20px radius), floating snackbar

## Storyboard
Use the storyboard in `brag-output/brag-plan.md` as the creative contract.

Scene summary:
1. The Problem — 3.5s — "You forgot when you opened these lenses." then "Again."
2. Meet LensGuard — 3s — gradient, eye icon, "Meet LensGuard.", "Your Smart Contact Lens Assistant"
3. Wear Tracking — 4.5s — wear card, ring sweeps Day 1→4 of 14, "10 days remaining" pill; label "Knows exactly how old your lenses are."
4. Reminders — 3.5s — notification banner "LensGuard — Time to take your lenses out 👁️"; "Daily reminders. Morning in. Evening out."
5. Start New Pair — 3.5s — Day 14/14 + red "Time to replace your lenses!", cursor taps "Start New Pair", ring resets to Day 1, green snackbar "New lens pair started!"
6. Outro — 2.5s — splash recreation + "Available now."

## Audio
- Audio role: warm bed, consistent light SFX layer (app-store posture)
- Audio arc: bed runs full length; one light SFX per feature moment; bell + music fade under the outro logo
- Music: `assets/music/happy-beats-business-moves-vol-11-by-ende-dot-app.mp3`
- Music treatment: start 0s, volume 0.35, fade to 0 over the final ~1.5s
- Music cue guidance: bundled preset `assets/music/cues/happy-beats-business-moves-vol-11-by-ende-dot-app.music-cues.json` (~114.8 BPM). Target strong cues: 3.70s (Meet LensGuard title), 12.65s (notification banner), 17.91s (ring reset). Beat grid ~0.53s apart for ring count ticks; sequential text holds to the reading floor.
- Audio-reactive treatment: skipped — per-frame audio extraction not available in this environment (no ffmpeg on PATH at composition time); beat-cue sync from the bundled preset used instead. Documented per /brag fallback rule.
- Audio-coupled moments:
  - Scene 1 "Again." — drop pop-in
  - Scene 2 title landing — soft impact, beat-locked near 3.70s
  - Scene 3 counter ticks — every-other-beat ticks; pill drop
  - Scene 4 banner arrival — light plate ping, beat-locked near 12.65s
  - Scene 5 — mouseclick on tap; glass clink on snackbar; reset near 17.91s
  - Scene 6 — impactBell_heavy_000 on logo; music fade
- SFX selection guidance: interface/drop_*, interface/click_* or ui/mouseclick1, impactPlate_light_*, impactGlass_light_*, impactSoft_medium_*, impactBell_heavy_000 — per brag `sfx-analysis.md` at `C:\Users\ameri\.claude\plugins\cache\brag\brag\0.1.0\skills\brag\assets\sfx\sfx-analysis.md`
- Exact SFX choice: Hyperframes chooses filenames, timestamps, density, and volume based on the implemented animation. Volumes: music ≤ 0.35–0.4, SFX 0.65–0.75.
- Audio files: copy chosen music + SFX into `brag-output/composition/assets/`

## Hyperframes Instructions
Use the current `hyperframes` skill and CLI workflow. Prefer native Hyperframes conventions over anything in `/brag`.

Requirements:
- Show at least one real UI, copy, or visual element from the source project (the wear-time card is mandatory).
- Keep all text readable in the final render (short label ~0.8s settled; sentences ~0.3s/word).
- Keep the video within 15–25 seconds.
- Include the planned music/SFX layer.
- Treat music cue metadata as optional timing hints; readability and pacing win.
- 1–3 strong cue locks (±0.15s); beat-grid snaps ±0.10s for small entrances.
- Use local assets for audio and runtime dependencies where possible.
- Run `npx hyperframes lint` and `validate` before render.
