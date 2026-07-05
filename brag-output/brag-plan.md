# Brag Plan: LensGuard

## What is this app?
LensGuard is a Flutter + Firebase app that tracks how old your current contact lens pair is ("Day 4 of 14"), reminds you to put lenses in and take them out, and watches retailer prices for your exact prescription.

## Rubric answers (Step 1)
1. **What is the app?** A smart assistant for contact lens wearers: wear-time tracking, daily insert/remove reminders, price alerts for your diopter.
2. **Funniest/most impressive claim?** The confirm dialog: "Make sure you've actually started a new pair of lenses." Also the wear ring hitting "Time to replace your lenses!"
3. **Visual hook?** The circular wear-time progress ring — "Day 4 / of 14" — in LensGuard Blue (#2196F3), turning orange near expiry.
4. **What to show from the UI?** The wear-time card (ring + "14-Day" badge + days-remaining pill + "Start New Pair" button), the splash logo (eye icon + gradient), a reminder notification.
5. **Shortest satisfying video?** ~20 seconds.
6. **Tone?** User direction: "Startup launch from 2020". Nearest preset: `app-store` — earnest, feature-card clean, played completely straight, with 2020-era launch tropes (gradient hero, "Meet X.", "Available now.").
7. **Audio?** Warm upbeat business bed (vol-11), light SFX layer: drop/click per feature moment, bell on outro.
8. **Share caption?** "It's giving 2020 launch video. LensGuard — the smart assistant for your contact lenses — knows exactly how old your lenses are, even when you don't."
9. **User flow worth showing?** Open dashboard → wear ring shows Day 4 of 14 → reminder notification arrives → tap "Start New Pair" → confirm → ring resets to Day 1, green "New lens pair started!" snackbar.

## The angle
A pitch-perfect 2020-era startup launch video for an app that tracks contact lenses. Played completely straight: the soft blue gradient, the "Meet LensGuard." reveal, the feature cards, the upbeat corporate beat. The charm is that the production energy of a Series A announcement is aimed at remembering to change your contacts.

## Hook (first 2-3 seconds)
White/blue-tinted screen, big type: **"You forgot when you opened these lenses."** Beat. Then: **"Again."** — the universal lens-wearer guilt, stated like a 2020 problem-slide.

## Key moments (the middle)
- The wear-time ring animating from Day 1 to **Day 4 of 14**, blue stroke sweeping, "10 days remaining" pill popping in below.
- A phone notification banner sliding in: "LensGuard · Time to take your lenses out 👁️" — daily reminders, morning and evening.
- The "Start New Pair" flow: cursor taps the button, ring snaps back to Day 1, green snackbar "New lens pair started!" — the product doing its thing.

## Outro / punchline
Eye icon + **LensGuard** on the 2196F3→1976D2 gradient (the actual splash screen), tagline verbatim from the app: "Your Smart Contact Lens Assistant." Then the 2020 sign-off: **"Available now."**

## User flow worth showing
Dashboard wear ring (Day 4 of 14) → reminder notification arrives → "Start New Pair" tapped → ring resets to Day 1 + success snackbar. Scenes 3–5 are this flow; it is the centerpiece.

## Tone
- Preset: `app-store`
- Creative direction: "Startup launch from 2020" (user-provided) — earnest overproduced launch energy, soft gradients, everything played straight.
- Interpretation: clean slides and smooth wipes, title-case copy, one claim per scene, consistent light SFX layer, upbeat corporate bed. No irony in the delivery — the era-accurate sincerity IS the tone.

## Format: landscape — 1920x1080
## Duration: 20.5s target

## Visual identity (from the project)
- Background: #FFFFFF (Material 3 light) with hero/outro gradient #2196F3 → #1976D2 (splash screen)
- Accent: #2196F3 ("LensGuard Blue", seed color in main.dart); warning orange for near-expiry; success green for snackbar
- Text: near-black on light, white on gradient
- Display font: Roboto (Flutter Material default) — heavy weight for headlines
- Body font: Roboto
- Strongest visual element: the circular wear-time progress indicator with "Day 4 / of 14" centered (wear_time_card.dart), 12px stroke, grey-200 track

## Share copy (draft)
"It's giving 2020 launch video. LensGuard — the smart assistant for your contact lenses — knows exactly how old your lenses are, even when you don't. 👁️"

## Audio direction
- Role: warm bed, consistent light SFX layer (app-store posture)
- Music: `happy-beats-business-moves-vol-11-by-ende-dot-app.mp3` (87.6s, warm and business-y — app-store fit)
- Music treatment: start at 0s, volume 0.35, fade out under the outro logo over the final ~1.5s
- Music cue guidance: preset read from `assets/music/cues/happy-beats-business-moves-vol-11-by-ende-dot-app.music-cues.md`. Tempo ~114.8 BPM. Strong cues at 3.70s (Meet LensGuard reveal), 12.65s (notification banner lands), 17.91s (ring resets to Day 1). Beat grid (~0.53s apart) available for the ring tick-up and pill pop-ins — but sequential TEXT holds to the reading floor (snap to every other beat).
- Audio-reactive treatment: subtle; music RMS may gently breathe the hero gradient glow and the phone-card presence. No waveform/equalizer visuals.
- SFX posture: consistent light layer (app-store): `interface/drop_*` or `interface/click_*` per feature moment at 0.65–0.75, one bell on the outro.
- Audio-coupled moments: ring count-up (soft ticks or single chip-stack), notification arrival (light plate ping), simulated button tap (ui/mouseclick or click), snackbar success (light glass clink), outro logo (impactBell_heavy).
- Restraint rule: never above music 0.5 / SFX 0.85; no stacked hits; no sound on every beat — this is a sincere launch video, not a hype reel.

## Storyboard

### Scene 1 — The Problem — 3.5s
Clean white screen, subtle blue tint. Heavy Roboto, centered: "You forgot when you opened these lenses." (holds ~1.8s), then "Again." pops below (holds ~1.2s).
Sequential/interaction: yes — second line "Again." arrives after the first settles.
Audio intent: music bed starts, builds familiarity; one soft accent on "Again."
Audio-coupled idea: `interface/drop_001` on "Again." pop-in.
Music: warm bed from 0s.
Transition mood: clean → Scene 2

### Scene 2 — Meet LensGuard — 3s
Full-bleed #2196F3→#1976D2 gradient. Eye icon (Material `visibility` glyph style) scales in, then "Meet LensGuard." in white, heavy. Small subline: "Your Smart Contact Lens Assistant" (verbatim from splash screen).
Sequential/interaction: yes — icon, then title, then subline.
Audio intent: the reveal lands on a strong cue; warm, confident.
Audio-coupled idea: reveal beat-locked near 3.70s strong cue; `impactSoft_medium` on title landing.
Music: bed continues.
Transition mood: smooth wipe → Scene 3

### Scene 3 — Wear Tracking (centerpiece) — 4.5s
Recreated wear-time card on light background: "Current Lens Pair" header, "14-Day" badge, circular progress ring animating stroke while center counts "Day 1 → Day 4" with "of 14" beneath (real UI from wear_time_card.dart). "10 days remaining" pill pops in under the ring. Side label: "Knows exactly how old your lenses are."
Sequential/interaction: yes — card slides in, ring sweeps + counter ticks 1→4, pill pops last.
Audio intent: playful precision; the count-up is the sonic moment.
Audio-coupled idea: counter ticks on beat grid (every other beat for readability), `interface/drop_002` on the pill.
Music: bed continues.
Transition mood: clean slide → Scene 4

### Scene 4 — Reminders — 3.5s
A phone-style notification banner slides in from the top: "LensGuard — Time to take your lenses out 👁️". Below, label: "Daily reminders. Morning in. Evening out."
Sequential/interaction: yes — banner slides in (simulated notification), label follows.
Audio intent: the notification arrival is the beat; crisp and light.
Audio-coupled idea: banner beat-locked near 12.65s strong cue; `impactPlate_light` ping on arrival.
Music: bed continues.
Transition mood: clean slide → Scene 5

### Scene 5 — Start New Pair — 3.5s
Back on the wear card at "Day 14 of 14" with the red "Time to replace your lenses!" pill. A cursor taps the blue "Start New Pair" button (real UI copy). Ring snaps back to "Day 1", pill turns to a green floating snackbar: "New lens pair started!" (verbatim).
Sequential/interaction: yes — simulated cursor tap on the button, then reset animation, then snackbar.
Audio intent: tap → relief → success.
Audio-coupled idea: `ui/mouseclick1` on tap; reset beat-locked near 17.91s cue; `impactGlass_light` clink on the snackbar.
Music: bed continues.
Transition mood: smooth wipe → Scene 6

### Scene 6 — Outro — 2.5s
The splash screen recreated: gradient, eye icon, "LensGuard", "Your Smart Contact Lens Assistant". Final line fades in: "Available now."
Sequential/interaction: none — one confident hold.
Audio intent: warm landing, music fades under the logo.
Audio-coupled idea: `impactBell_heavy_000` as the logo lands; music fades out over final 1.5s.
Music: bed fades to 0 by end.
Transition mood: soft → end

**Total: 3.5 + 3 + 4.5 + 3.5 + 3.5 + 2.5 = 20.5s**

**Music mood for this video:** upbeat corporate-warm (2020 launch energy)
**Audio summary:** a warm business bed runs the full video with one light SFX per feature moment; three strong-cue locks (reveal, notification, reset) and a bell + fade on the logo.
