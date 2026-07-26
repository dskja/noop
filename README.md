> **Project status.** This is an actively maintained fork of [NOOP](https://github.com/ParthJadhav/noop),
> originally preserved from the deleted `github.com/NoopApp/noop` by ParthJadhav. This fork continues
> development, professionalization, and expansion of the codebase for the community.
>
> **Credits:** The original NOOP project was built on community interoperability work — see
> [Attribution](#attribution) for the full list of upstream contributors. This fork builds on that
> foundation with gratitude.
>
> To WHOOP: you can request archival of this repository at any moment by creating an issue.

<p align="center">
  <img src="docs/assets/logo-v3.png" alt="NOOP" width="72">
</p>

<h1 align="center">NOOP</h1>

<p align="center"><b>Your strap. Your data. Your machine. Offline, on-device, no cloud.</b></p>

<p align="center"><sub>Now in the all-new <b>Liquid Metal</b> design: one living look across iPhone, Android and Mac.</sub></p>

<p align="center">
  <img alt="Platforms" src="https://img.shields.io/badge/platforms-macOS%20%C2%B7%20Android%20%C2%B7%20iOS-E8B84B?style=flat-square">
  <img alt="Local first" src="https://img.shields.io/badge/local-first-E8B84B?style=flat-square">
  <img alt="Account free" src="https://img.shields.io/badge/account-free-C8902F?style=flat-square">
  <img alt="WHOOP 4 and 5" src="https://img.shields.io/badge/works%20with-WHOOP%204.0%20%26%205.0-6B737B?style=flat-square">
  <a href="LICENSE"><img alt="License: PolyForm Noncommercial 1.0.0" src="https://img.shields.io/badge/license-PolyForm%20Noncommercial%201.0.0-6B737B?style=flat-square"></a>
  <a href="https://www.reddit.com/r/NOOPApp/"><img alt="Community: r/NOOPApp" src="https://img.shields.io/badge/community-r%2FNOOPApp-E8B84B?style=flat-square&logo=reddit&logoColor=white"></a>
  <a href="https://discord.com/invite/nHK9FHczu"><img alt="Chat: Discord" src="https://img.shields.io/badge/chat-Discord-5865F2?style=flat-square&logo=discord&logoColor=white"></a>
</p>

<p align="center">
  <a href="https://github.com/dskja/noop/releases/latest"><img alt="Latest release" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdskja%2Fnoop%2Fmain%2Fdocs%2Fstats%2Frelease.json&style=flat-square"></a>
  <a href="https://github.com/dskja/noop/stargazers"><img alt="Stars" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdskja%2Fnoop%2Fmain%2Fdocs%2Fstats%2Fstars.json&style=flat-square"></a>
</p>

<p align="center">
  <a href="#download">⬇&nbsp;Download</a> ·
  <a href="https://github.com/ParthJadhav/noop/wiki/FAQ">❓&nbsp;FAQ</a> ·
  <a href="https://discord.com/invite/nHK9FHczu">💬&nbsp;Discord</a> ·
  <a href="https://www.reddit.com/r/NOOPApp/">👽&nbsp;Reddit</a> ·
  <a href="#features">Features</a> ·
  <a href="docs/PROTOCOL.md">Protocol</a> ·
  <a href="mailto:thenoopapp@gmail.com">Contact</a>
</p>

<p align="center">
  <a href="https://github.com/dskja/noop/releases/latest"><img src="docs/assets/hero-v8.jpg" alt="NOOP in the new Liquid Metal design, on iPhone, Mac and Android" width="820"></a>
</p>

<p align="center">
  <img src="docs/assets/shot-ios-today.png" alt="Today on iPhone" width="218">
  &nbsp;&nbsp;
  <img src="docs/assets/shot-android-today.png" alt="Today on Android" width="218">
  &nbsp;&nbsp;
  <img src="docs/assets/shot-android-trend.png" alt="A metric's own trend on Android" width="218">
</p>
<p align="center"><sub>The all-new <b>Liquid Metal</b> look: living liquid scores, a sky that moves with your day, rebuilt on every screen. The same Today on iPhone and Android, and a metric&rsquo;s own trend. One design across iPhone, Android &amp; Mac.</sub></p>

---

## Project Continuity

NOOP remains account-free, local-first software. This fork continues the work started by the original
NOOP project and preserved by ParthJadhav. It is actively maintained and developed for the community
of WHOOP users who want offline, on-device access to their own biometric data.

The original project's spirit — offline by design, transparent math, no account, no cloud — carries
forward unchanged. This fork professionalizes the codebase, expands platform support, and keeps
builds available for everyone who relies on it.

---

## Download

Pre-built apps you can run right now:

<p>
  <a href="https://github.com/dskja/noop/releases/latest"><img alt="Version" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdskja%2Fnoop%2Fmain%2Fdocs%2Fstats%2Frelease.json&style=flat-square"></a>
  <img alt="Released" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdskja%2Fnoop%2Fmain%2Fdocs%2Fstats%2Freleased.json&style=flat-square">
</p>

| Platform | Build | Notes |
|---|---|---|
| **macOS** | `NOOP-vX-macos.zip` (see [Releases](https://github.com/dskja/noop/releases)) | Apple Silicon + Intel. Unzip and drag `NOOP.app` to Applications. Not notarized — see **First launch on macOS** below. |
| **Android** | `NOOP-vX.apk` (see [Releases](https://github.com/dskja/noop/releases)) | The full app. `minSdk 26` (Android 8+). Sideload — enable "install unknown apps". Blocked by Play Protect? See **Installing on Android** below. |
| **iOS** | `NOOP-vX-ios.ipa` (see [Releases](https://github.com/dskja/noop/releases)) — sideload with AltStore/SideStore | Now a **direct download**. The `.ipa` is unsigned; **you** sign it on your iPhone with your own free Apple ID (no App Store, no developer account — NOOP stays anonymous). Re-signs every 7 days (AltStore automates it); Apple Health + Live Activity widgets may be limited under a free signing identity. See [docs/IOS.md](docs/IOS.md). Or build from source in Xcode. |

> **First launch on macOS.** NOOP is **not notarized** by Apple — notarization needs a paid Apple
> Developer ID tied to a real identity, which doesn't fit an anonymous, free project. The app *is*
> sandboxed and ad-hoc code-signed, and the full source is here to inspect. Because it isn't notarized,
> macOS Gatekeeper blocks it on first open (you may see *"damaged"* or *"unverified developer"* — that's
> the download quarantine flag, not real damage). To open it, do one of these **once**:
>
> - **Terminal (most reliable):** drag `NOOP.app` to Applications, then run
>   `xattr -dr com.apple.quarantine /Applications/NOOP.app` and open NOOP normally.
> - **No Terminal:** double-click NOOP (it'll be blocked), then open **System Settings → Privacy &
>   Security**, scroll to the bottom, and click **"Open Anyway"** next to NOOP. (On macOS 14 and
>   earlier you can also right-click the app → **Open**.)
>
> Prefer to avoid this entirely? Build from source — see [Quickstart](#quickstart-macos).

> **Installing on Android (Play Protect blocked it?).** NOOP isn't on the Play Store — it's an
> **unsigned, source-available APK** you sideload, because the project is anonymous and has no paid
> Play identity to publish or sign under. So Android treats it as an "unknown app" and **Google
> Play Protect** may warn or block on install (most stubbornly on stock Pixel / recent Android).
> Nothing is wrong with the file — it's just missing a Play signature. To get it on:
>
> - **Tap "Install anyway."** When the warning appears, choose **More details → Install anyway**.
> - **No "Install anyway" button?** It can vanish after a first install + uninstall. Grant the source
>   directly: **Settings → Apps → Special app access → Install unknown apps**, pick the **browser or
>   file manager you're installing from**, turn on **"Allow from this source"**, then open the APK again.
> - **Still blocked by Play Protect?** It's your call to make for an unsigned app you trust: open the
>   **Play Store → your profile icon → Play Protect → ⚙ Settings**, toggle **"Scan apps with Play
>   Protect" off**, install NOOP, then switch it **back on**.
> - **Reinstalling is safe.** Uninstalling and installing again won't hurt anything — NOOP keeps all
>   data on-device with `allowBackup=false`, so a reinstall simply starts fresh. There's no cloud copy
>   to lose either way.

Prefer to build it yourself? See [`docs/BUILD.md`](docs/BUILD.md).

Everything runs **offline**. The only feature that ever uses the network is the optional **AI Coach**, and only with your own API key.

---

NOOP is a standalone, fully **offline** companion app for WHOOP straps (4.0 and
5.0). It pairs directly with the strap over Bluetooth, stores everything on your
own device in SQLite, imports your existing WHOOP and Apple Health history, and
computes recovery, strain, HRV, and sleep **locally**, with no WHOOP account and
no WHOOP cloud.

It is built on prior community interoperability work and exists for one
reason: to let someone who owns a WHOOP strap read **their own biometric data**
from **their own device**, on a machine **they** control.

> **Not affiliated with WHOOP.** NOOP is an independent, unofficial
> interoperability project. It is not affiliated with, endorsed by, or connected
> to WHOOP, Inc. "WHOOP" is used only to identify the hardware NOOP talks to. Use
> it only with a device you own, and not in breach of any agreement that applies
> to you. **NOOP is not a medical device**; every derived metric is an
> approximation, not clinical data. See [`DISCLAIMER.md`](DISCLAIMER.md).

---

## Contents

- [Why NOOP](#why-noop)
- [Features](#features)
- [Platform status](#platform-status)
- [Architecture](#architecture)
- [Quickstart (macOS)](#quickstart-macos)
- [How your data flows](#how-your-data-flows)
- [Privacy](#privacy)
- [Attribution](#attribution)
- [Support (optional)](#support-optional)
- [Disclaimer](#disclaimer)
- [License](#license)
- [Roadmap](#roadmap)
- [Docs](#docs)

---

## Why NOOP

You bought the strap. The biometric stream it produces is yours. NOOP is built on
that premise:

- **Own your data.** NOOP reads heart rate, R-R intervals, SpO₂, skin temperature,
  respiration, accelerometer/gravity, battery, and event data straight off the
  strap over Bluetooth and writes it to a local SQLite database. Nothing is
  uploaded anywhere.
- **Account-free and local.** NOOP never logs into a WHOOP account and never hits
  a WHOOP server. It does not bypass any login, paywall, or DRM; it simply talks to
  a device you own and reads data you generated.
- **Bring your history.** Already have years of data in the official app or in
  Apple Health? Import the WHOOP CSV export and/or your Apple Health `export.xml`
  once, and it's permanently on your machine.
- **Transparent math.** Recovery, strain, HRV, and sleep are recomputed on-device
  from documented, citable methods (Task Force 1996 HRV, Karvonen %HRR, Edwards /
  Banister TRIMP, Tanaka HRmax, and so on). The algorithms are approximations of —
  not reproductions of — any proprietary model, and every analyzer file documents
  exactly what it does.

---

## Features

The macOS reference app organizes everything behind a single sidebar
(`Strand/App/RootView.swift`). Each item below is a real screen in
`Strand/Screens/`. The same feature set ships on macOS, Android, and iOS via the
shared cross-platform code.

| Screen | What it does |
|---|---|
| **Today** (Control Center) | Home dashboard: recovery ring, a "today's synthesis" insight, a grid of stat tiles (recovery, strain, sleep, HRV, RHR, SpO₂, respiratory, steps, weight, calories) each with a 14-day sparkline, live strap **battery %** and HR trend, recent workouts, and a data-sources footer. |
| **Readiness** | An on-device "should you push today?" read that synthesizes established sports-science signals from your own history — HRV vs your baseline (Plews/Buchheit), resting-HR drift (Lamberts), sleeping respiratory-rate drift, training-load balance (acute:chronic workload ratio, Gabbett) and training monotony (Foster) — into a single headline (Primed / Balanced / Strained / Run down) with the drivers behind it. Pure local math, not medical advice. |
| **Live** | Real-time view of the connected strap — heart rate and frame stream as they arrive (~1 Hz). |
| **Breathe** | **HRV haptic breathing biofeedback.** The strap both *measures* HRV (R-R intervals) and *buzzes* its haptic motor, so NOOP paces your breath with felt cues (one buzz inhale, two exhale) and shows live HR + rolling RMSSD responding as the session deepens. Presets: Relax 4-6, Coherence 5.5, Box 4-4. Each session reports a **pre/post HRV outcome** so you can see how much you settled. |
| **Intervals** | **Silent haptic HIIT timer.** The strap buzzes every transition (triple-buzz into WORK, single into REST, 3-2-1 tick at phase ends, long buzz on finish) so you train hands-free. Falls back to a glanceable visual timer with no strap. |
| **Explore** (Metric Explorer) | Interrogate any single metric over time, built from the metric catalog (`Strand/Data/MetricCatalog.swift`). |
| **Compare** | Plot two metrics together / against each other over a shared timeline. |
| **Insights** | Behavioral and correlational insights derived from your own series — including **Activity Cost**, which learns what each activity type typically costs your next-morning recovery (and how long you take to bounce back) from your own history. |
| **Sleep** | Sleep sessions with a hypnogram, stage breakdown, efficiency, resting HR, and HRV — computed by the on-device sleep stager. Browse back through **past nights**, not just last night. |
| **Trends** | Long-range trends across recovery, strain, sleep, and biometrics — and a **shareable one-page PDF report** (recovery / sleep / HRV / resting HR / strain over a range you choose), rendered entirely on-device for a doctor, coach, or your own records. |
| **Workouts** | Detected and manual exercise sessions with strain and heart-rate detail. Tap any session for a full **detail view** — its HR curve over the workout, time in each HR zone, duration, avg/max HR, and the Effort it added. |
| **Health** | Biometric overview (HR, HRV, SpO₂, skin temperature, respiratory rate, etc.). |
| **Stress** | Day-level stress / autonomic load visualization. |
| **Mind** | A quick **daily mood check-in** that correlates how you feel against your own recovery, sleep and HRV over time — so you can see what actually moves your mood. On-device and **non-clinical**: a self-reflection log, not a mental-health assessment. |
| **Apple Health** | Browse and reconcile data imported from your Apple Health export. |
| **Data Sources** | One-tap import of a WHOOP CSV export, an Apple Health export, or a **nutrition CSV** (Cronometer / MacroFactor), plus live-strap status. "Bring your history in once, then it's yours." |
| **Notifications** | Configure local notifications and thresholds (`Strand/Data/NotificationSettingsStore.swift`). |
| **Automations** | Turn the strap's physical inputs and live biometrics into Mac actions — all on-device (see below). |
| **Coach** | An optional **AI Coach** you can ask about your data in plain language. It's the one feature that can ever use the network: off until you add your own key — Anthropic, OpenAI, or any OpenAI-compatible endpoint including a local/self-hosted model (Ollama, LM Studio) — and it sends only a short text summary of recent metrics plus your question, never raw streams or identifiers. With a local model the conversation never leaves your machine. Available on macOS, Android, and iOS. See [`docs/PRIVACY_SECURITY.md`](docs/PRIVACY_SECURITY.md). |
| **Settings** | Profile, preferences, **step calibration** (tune the stride/step estimate to your own walking), unit choices, the in-app **What's new** changelog, and an opt-in **Experimental** section (WHOOP 5/MG protocol probes). On **iOS**, also **Export for Shortcuts** — a HealthKit-free path that hands your metrics to Apple Health via the Shortcuts app. |
| **Support** | Attribution, project information, and contact details. |

There is also a **menu-bar extra** (`Strand/MenuBar/MenuBarContent.swift`) with a
glanceable live HR readout and a compact popover, a first-run **onboarding wizard**
that sets expectations (independent/experimental, WHOOP 4.0 vs 5/MG, on-device only),
and an in-app **"What's new"** changelog shown after each update.

### Automations (on-device)

`Strand/Screens/AutomationsView.swift` + `Strand/System/MacActions.swift`:

- **Double-tap → Mac action.** Double-tap the strap to lock the Mac, buzz back to
  confirm, mark a moment, do nothing, or run any macOS **Shortcut** by name (via
  the `shortcuts://` URL scheme, so it's sandbox-friendly).
- **Wear & presence.** Lock the Mac (or run a Shortcut) the moment the strap
  leaves your wrist; run a Shortcut when it goes back on. *(macOS reserves true
  auto-**unlock** for Apple Watch — NOOP can lock, not unlock.)*
- **Haptic coaching.** HR-zone coaching and an experimental resting-stress nudge —
  the strap buzzes so you don't have to watch a screen.
- **Inactivity reminder.** An optional gentle wrist buzz after you've been sitting
  still too long — your idle threshold, your active hours, a re-nudge cooldown,
  respects quiet hours, **off by default**.
- **Smart alarm.** Arms the strap's own **firmware** alarm to buzz at your wake
  time (still fires if the Mac is asleep or NOOP is closed), with an optional
  light-sleep wake window when the Mac stays awake and connected.

---

## Platform status

NOOP's logic lives in cross-platform Swift packages, and the same protocol,
storage, analytics, and scoring is ported to Kotlin on Android. Both apps pair
with the strap and **score recovery, strain and sleep on your own device** — no
import required.

<p>
  <a href="https://github.com/dskja/noop/releases/latest"><img alt="Latest across all platforms" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdskja%2Fnoop%2Fmain%2Fdocs%2Fstats%2Frelease.json&style=flat-square"></a>
  <img alt="Commits per month" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdskja%2Fnoop%2Fmain%2Fdocs%2Fstats%2Flastcommit.json&style=flat-square">
  <img alt="Top language" src="https://img.shields.io/badge/languages-Swift%20%C2%B7%20Kotlin-E8B84B?style=flat-square">
  <img alt="Code size" src="https://img.shields.io/badge/build-from%20source-6B737B?style=flat-square">
</p>

| Platform | Status |
|---|---|
| **macOS** | ✅ Full app (`Strand/`, SwiftUI, macOS 13+). Pairs over BLE, offloads the strap's history, and scores recovery / strain / sleep on-device. The complete feature set above runs here. |
| **Android** | ✅ Full app (`android/`, Jetpack Compose, Android 8+). Pairs over BLE, persists and scores on-device, and imports WHOOP / Apple Health / Health Connect. Grab the APK from [Releases](https://github.com/dskja/noop/releases). |
| **iOS** | 📲 **Direct download**: an unsigned `.ipa` you sideload with AltStore/SideStore — it signs on your iPhone with your *own* free Apple ID, so there's an anonymous install path with no App Store / developer account (see [docs/IOS.md](docs/IOS.md)). Also still builds from source in Xcode. Shares the cross-platform Swift packages, so scoring matches macOS. Newer and less battle-tested than macOS/Android — live BLE on a real iPhone is still being validated; Apple Health + Live Activity widgets can be limited under a free signing identity. |

### Strap support

NOOP is an independent, **experimental** project — capable, but a work in progress.

| Strap | Status |
|---|---|
| **WHOOP 4.0** | ✅ The tested, supported path. Live HR, recovery, strain, sleep, history offload — the full experience. (v1.95 also unlocked sleep + recovery on the newer "v25" 4.0 firmware layout that earlier versions could only read live HR from.) |
| **WHOOP 5.0 / MG** | 🧪 **Live heart rate works** (confirmed on real hardware). Pick "WHOOP 5.0 / MG" before connecting — and see the pairing note below, because you can't just scan for it. Deeper 5/MG metrics (recovery, strain, sleep) are still being mapped; there's an opt-in **Settings → Experimental** toggle for 5/MG owners who want to help document the protocol. |

> ### WHOOP 5.0 / MG analysis limits
>
> NOOP's analysis screens and algorithms can only be as complete as the sensor inputs it can
> reliably decode. On WHOOP 5.0 / MG, important overnight inputs remain unavailable or incomplete:
>
> | Input / output | Current direct-from-strap status |
> |---|---|
> | Sleep duration / detection | Experimental; can fall back to heart rate when motion is sparse |
> | Sleep stages | Approximate and not reliable while full overnight motion and cardiorespiratory inputs remain incomplete |
> | Skin temperature | Raw values decode on supported historical layouts; not available consistently across 5/MG firmware |
> | Blood oxygen / SpO₂ | Not recoverable offline from current time-multiplexed PPG data |
> | Overnight HRV and respiratory rate | Incomplete unless sufficient R-R intervals are captured |
>
> In short: seeing the Sleep, Health, Readiness, or Insights screens doesn't mean their deepest
> analysis is available from a WHOOP 5.0 / MG alone yet — scoring and correlations can't conjure a
> measurement the strap hasn't given up. Decoding these inputs reliably is what we're working on, and
> it's the prerequisite for the full 5/MG picture. We'd always rather tell you that straight.
>
> ### Pairing a WHOOP 5.0 / MG — read this first
>
> A WHOOP strap holds an encrypted Bluetooth **bond with only one device at a time**, and yours is
> normally bonded to the **official WHOOP app** on your phone. **You can't just scan for it in NOOP** —
> if the strap is still bonded to the WHOOP app, NOOP's pairing is refused and the strap log shows
> *"Encryption is insufficient"* / *"bond refused."* (Live **heart rate** is the exception — it rides the
> standard Bluetooth heart-rate profile, so it streams without a bond. But pairing — needed for the
> deeper features — does not.)
>
> **To pair properly:**
> 1. **Close the official WHOOP app** on your phone (fully quit it, or turn that phone's Bluetooth off) so
>    it isn't holding the bond.
> 2. **Put the strap in pairing mode** — on a 5.0/MG, **tap the band repeatedly** (firm taps on the
>    sensor) until the **LEDs flash blue**.
> 3. In NOOP: **Live → choose "WHOOP 5.0 / MG" → Scan & Connect.** Success looks like
>    *"CLIENT_HELLO acked — link established"* in the strap log (not *"bond refused"*). It can take a
>    couple of attempts.
>
> **Only one device at a time.** Because the strap holds a single bond, don't leave it connected to your
> phone *and* your Mac (or the WHOOP app) at once — live heart rate will still show on all of them
> (that rides the bond-free standard profile), but **none** of them will have the real encrypted bond.
> If HR streams fine yet **buzz, alarm, double-tap and history don't work**, that's the tell: the strap
> isn't truly bonded to this device. Free it from everything else, then pair here.
>
> Bonding to NOOP may take the strap's bond away from the WHOOP app, so the official app might need to
> re-pair afterwards. This is the **hardest part of 5/MG support** — if it refuses, you're almost
> certainly still bonded to the WHOOP app (or another device); free the strap and retry.

The app always tells you what's live now versus still building, both in onboarding and on each screen.

### What to expect when you start

NOOP computes your scores on your own device, so like any recovery wearable it
needs a little data before everything fills in:

- **Live heart rate** shows the moment the strap connects.
- **Strain and sleep** appear after you've worn it and synced — the strap's last
  ~14 days offload automatically over the first few minutes.
- **Recovery** needs a few nights for the app to learn your personal baseline,
  then sharpens each night. WHOOP makes you wait for the same reason.
- **In a hurry?** Import your WHOOP export in Data Sources and your full history
  fills in about a minute.

---

## Architecture

The repository is split into platform-pure Swift packages plus a macOS app target.
All packages declare both `.iOS(.v16)` and `.macOS(.v13)`; framework-specific UI is
guarded with `#if canImport(UIKit)` / `#if canImport(AppKit)`.

```
Strand/                  macOS SwiftUI reference app (this is what you build)
Packages/
  WhoopProtocol/         BLE frame parsing, CRC, command/event/packet decode
  WhoopStore/            GRDB/SQLite persistence (migrations, streams, caches)
  StrandAnalytics/       HRV / recovery / strain / sleep / correlation math
  StrandImport/          WHOOP CSV + Apple Health importers
  StrandDesign/          SwiftUI design system (palette, components, charts)
Tools/Backfill/          CLI tool for backfilling decoded data
Fixtures/                sample WHOOP export for tests
```

### `WhoopProtocol` — the protocol-support core

Platform-pure (no CoreBluetooth import) so it runs in tests and CLI tools
unchanged. It implements the on-wire frame format for both strap generations,
so NOOP can speak to a device you own:

```swift
public enum DeviceFamily: String, Sendable, CaseIterable {
    case whoop4   // CRC8 (poly 0x07) header check; service 61080001-…
    case whoop5   // CRC16-Modbus header check, "puffin" packet types; service fd4b0001-…
}
```

Decoding is schema-driven (`Resources/whoop_protocol.json`) and includes CRC8,
CRC16-Modbus, and zlib CRC-32 implementations, frame framing, value
interpretation, and historical-stream reassembly. The app layer (`Strand/BLE/`,
`Strand/Collect/`) wraps these UUID *strings* in `CBUUID` and handles bonding,
offload, and live notifications.

### `WhoopStore` — local SQLite via GRDB

Everything is stored on-device in SQLite (using
[GRDB.swift](https://github.com/groue/GRDB.swift)). The schema is a versioned
migrator (`Database.swift`, currently through `v9`). Examples of decoded-stream
tables created in `v1`–`v3`:

```sql
CREATE TABLE hrSample      (deviceId TEXT, ts INTEGER, bpm INTEGER, PRIMARY KEY(deviceId, ts));
CREATE TABLE rrInterval    (deviceId TEXT, ts INTEGER, rrMs INTEGER, PRIMARY KEY(deviceId, ts, rrMs));
CREATE TABLE spo2Sample    (deviceId TEXT, ts INTEGER, red INTEGER, ir INTEGER, PRIMARY KEY(deviceId, ts));
CREATE TABLE skinTempSample(deviceId TEXT, ts INTEGER, raw INTEGER, PRIMARY KEY(deviceId, ts));
CREATE TABLE respSample    (deviceId TEXT, ts INTEGER, raw INTEGER, PRIMARY KEY(deviceId, ts));
```

Later migrations add server-derived metric caches (`sleepSession`, `dailyMetric`),
cursors, a raw frame outbox, and more.

### `StrandAnalytics` — transparent, on-device math

Pure, database-free analyzers. Each is documented and grounded in published
methods (and is explicitly an approximation, not a reproduction of any proprietary
model):

| File | Computes |
|---|---|
| `HRVAnalyzer.swift` | RMSSD + SDNN from R-R intervals (Task Force 1996), with range + Malik ectopic filtering. |
| `RecoveryScorer.swift` | A 0–100 recovery score: HRV-dominant z-score + logistic composite vs personal baselines. |
| `StrainScorer.swift` | A 0–21 logarithmic strain scale from %HRR (Karvonen) and Edwards / Banister TRIMP. |
| `SleepStager.swift` | Sleep/wake detection + approximate 4-class staging from cardiorespiratory + gravity features. |
| `CorrelationEngine.swift` | Pearson r, OLS regression, day-aligned and lagged correlations between two series. |
| `WorkoutDetector.swift`, `Baselines.swift`, `BehaviorInsights.swift`, `AnalyticsEngine.swift` | Workout detection, rolling baselines, behavioral insights, and the per-day orchestrator. |

### `StrandImport` — bring your own history

- **WHOOP CSV export** (`WhoopExportImporter.swift`): header-name-driven, tolerant
  parser for `physiological_cycles.csv`, `sleeps.csv`, `workouts.csv`, and
  `journal_entries.csv`, from a folder or `.zip`. The same schema covers WHOOP 4 /
  5 / MG.
- **Apple Health export** (`AppleHealthImporter.swift`): a **streaming** SAX parser
  (`XMLParser`) for `export.xml` (which can exceed 1 GB), with correlation-dedupe,
  unit normalization (e.g. SpO₂ fraction → %), and sleep-stage mapping.
- **Nutrition CSV** — a tolerant importer for daily-nutrition exports from
  **Cronometer** and **MacroFactor**, so calories and macros line up alongside your
  recovery and sleep on a shared timeline.

### `StrandDesign` — the SwiftUI design system

Palette, typography, motion, and reusable components/charts (`RecoveryRing`,
`StrainGauge`, `Hypnogram`, `Sparkline`, `TrendChart`, `YearHeatStrip`,
`StrandCard`, `StatePill`, …) — no external UI dependencies.

---

## Quickstart (macOS)

**Requirements:** macOS 13+, Xcode 15+ (Swift 5.9), and a Mac with Bluetooth. To
pair live, you need your own WHOOP strap; to just explore, you can import a CSV /
Apple Health export instead.

The Xcode project is generated from [`project.yml`](project.yml) with
[XcodeGen](https://github.com/yonaskolb/XcodeGen).

```bash
# 1. Clone
git clone <your-fork-url> NOOP
cd NOOP

# 2. (Re)generate the Xcode project from project.yml
brew install xcodegen   # if you don't have it
xcodegen generate

# 3. Open and run
open Strand.xcodeproj
# Select the "Strand" scheme → Run (⌘R). The built app is named NOOP.
```

Notes:

- Bundle id `com.noopapp.noop`, product name **NOOP**, sandboxed with the
  Bluetooth and user-selected-files entitlements.
- Swift Package Manager resolves the only third-party dependencies automatically:
  **GRDB.swift** (SQLite) and **ZIPFoundation** (export unzip).
- Run the tests from Xcode (the `StrandTests` target + each package's test target),
  or per-package with `swift test` inside `Packages/<Name>/`.

To explore without an Xcode project, the packages build on their own:

```bash
cd Packages/WhoopProtocol && swift build && swift test
```

---

## How your data flows

```
WHOOP strap ──BLE──▶ Strand/BLE + Strand/Collect ──▶ WhoopProtocol (decode)
                                                          │
WHOOP CSV   ─┐                                            ▼
Apple Health ├─▶ StrandImport (parse) ──────────▶ WhoopStore (local SQLite)
Nutrition CSV┘                                            │
                                                          ▼
                                            StrandAnalytics (recovery/strain/
                                            HRV/sleep, on-device)
                                                          │
                                                          ▼
                                          Strand (SwiftUI) + StrandDesign
```

Every arrow stays on your machine.

---

## Privacy

**Offline by design.** NOOP has no server, no telemetry, and no account. Your
strap data, imports, and computed metrics live in a local SQLite database on your
device and never leave it.

---

## Attribution

NOOP stands on community interoperability and protocol-documentation work. With
thanks:

- **`johnmiddleton12/my-whoop`** — the WHOOP 4.0 BLE protocol; the `WhoopProtocol`
  and `WhoopStore` packages and the collection logic are adapted from this work.
- **`b-nnett/goose`** — the WHOOP 5.0 / MG BLE protocol documentation (the `fd4b0001-…`
  service family, CRC16-Modbus header, and "puffin" packet types) that NOOP's
  WHOOP 5.0 path is ported from.
- **`groue/GRDB.swift`** — SQLite persistence.
- **`weichsel/ZIPFoundation`** — export unzipping.

NOOP contains no WHOOP proprietary code, firmware, logos, or assets, and performs
no DRM circumvention. Full detail in [`ATTRIBUTION.md`](ATTRIBUTION.md).

---

## Support

**Community:** questions, setup help, tips, and release news → **[r/NOOPApp](https://www.reddit.com/r/NOOPApp/)**.
**Bug reports:** please use **[GitHub Issues](https://github.com/dskja/noop/issues)** — there's a template, and they're tracked, deduped and linked to fixes (include a strap log).
**Contact:** [thenoopapp@gmail.com](mailto:thenoopapp@gmail.com) · or open a GitHub issue.

---

## Disclaimer

NOOP is an independent, unofficial, non-commercial interoperability project. It is
**not affiliated with, endorsed by, or connected to WHOOP, Inc.** All references to
"WHOOP" are nominative — used only to identify the third-party hardware NOOP
interoperates with.

**NOOP is not a medical device.** Heart rate, HRV, recovery, strain, sleep stages,
SpO₂, respiratory rate, and skin temperature are **approximations** computed from
published methods. They are not clinically validated and are not medical advice. Do
not use them to diagnose, treat, or make health decisions — consult a qualified
professional.

Provided **as-is**, with **no warranty**, for **personal and educational use**. You
use it at your own risk. Read the full notice in [`DISCLAIMER.md`](DISCLAIMER.md).

---

## License

NOOP is **source-available** under the [PolyForm Noncommercial License 1.0.0](LICENSE):
**free for personal and other non-commercial use** — read it, run it, fork it, and
contribute. Commercial use is not granted by this license. (PolyForm Noncommercial is
a proper software license with patent terms; it is deliberately *not* an OSI
"open-source" licence, because that would permit the commercial use this project's
non-commercial nature rules out.)

The license covers NOOP's own original code and docs. Protocol facts (frame layouts,
command numbers, byte offsets) are uncopyrightable and free to reuse; bundled
dependencies keep their own licenses (GRDB.swift and ZIPFoundation are MIT — see
[`NOTICE`](NOTICE)). By opening a pull request you agree your contribution is licensed
under the same terms — see [`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md).

### Mirroring & forking

NOOP is public and built to be hard to erase. **Clone it freely** — `git clone https://github.com/dskja/noop.git` — and you're welcome to **mirror or fork it** to Codeberg, GitLab or your own server. More copies make the project more resilient.

Two simple asks:

- **Keep it non-commercial** and keep the [`LICENSE`](LICENSE) + `Copyright 2026 NoopApp` notice intact (PolyForm Noncommercial — mirror and use freely, just don't sell it or ship it in a paid product).
- **Credit upstream:** This fork builds on [ParthJadhav/noop](https://github.com/ParthJadhav/noop) (preservation) and the original NOOP project, which in turn built on `johnmiddleton12/my-whoop` (WHOOP 4.0 protocol) and `b-nnett/goose` (WHOOP 5.0 protocol). See [Attribution](#attribution) for the full chain.

That's it — copy away.

---

## Docs

- [`CHANGELOG.md`](CHANGELOG.md) — release history and what to expect (also shown in-app under **What's new**).
- [`DISCLAIMER.md`](DISCLAIMER.md) — trademark, interoperability, and medical/legal notice.
- [`ATTRIBUTION.md`](ATTRIBUTION.md) — full credits and licensing notes.
- [`project.yml`](project.yml) — XcodeGen project definition (source of `Strand.xcodeproj`).

---

## Roadmap

The following is a living backlog of planned and candidate work for NOOP. It is intentionally broad: short-term polish, mid-term feature parity across iPhone, Mac and Android, longer-term protocol expansion for WHOOP 5.0/MG, and ongoing analytical and infrastructure work. Items are grouped by domain; the order within a section is not a strict priority order. Checked items are those already merged; most remain open research, implementation, or QA tasks.

### Strand / v5 hub UI & navigation

- Harden iOS `FloatingTabBar` active-state for `Insights`, `Health` and `Sources`.
- Fix Android `BottomBar` active icon state when routing through `Sources`.
- Synchronise macOS sidebar initial expansion for `Insights`, `Health` and `Sources`.
- Add compact collapsed sidebar mode on macOS.
- Support tab bar theming synced to `Liquid Metal` time-of-day palette.
- Implement iOS `Sources` search/filter for long destination lists.
- Implement Android `Sources` search/filter for long destination lists.
- Add macOS sidebar pinning for favourite destinations.
- Add iOS `Sources` recent-items row.
- Add Android `Sources` recent-items row.
- Animate `Sources` group expand/collapse on all three platforms.
- Add haptic feedback to iOS tab selection.
- Add haptic feedback to Android tab selection.
- Unify empty-state illustrations across the three shells.
- Add per-platform onboarding hints for the new hub model.
- Re-evaluate `Settings` placement on iOS vs macOS vs Android for parity.
- Add `Sources` drag-to-reorder for user favourites (local preference).
- Add `Sources` badge counts for un-synced data / errors.
- Ensure `Back` gesture on Android always returns to the correct hub root.
- Reconcile `NavGroup` IDs with `MoreSectionPrefs` keys for stable persistence.

### Today tab

- Add `RecoveryForecast` evening card to Today.
- Show `IllnessSignal` "Heads-Up" card when raised.
- Add `DaytimeStress` hourly sparkline card.
- Add configurable Today card reordering.
- Add Today "good morning" synthesis with sleep + recovery narrative.
- Add live battery tile with charging state.
- Show last-sync timestamp with "stale" warning.
- Add today's `HydrationGoalEngine` progress tile.
- Add `StepsEstimateEngine` daily steps tile on iOS.
- Add `StepsEstimateEngine` daily steps tile on Android.
- Add `StepsEstimateEngine` daily steps tile on macOS.
- Add weight entry shortcut on Today.
- Add body-temperature trend tile.
- Add `WeeklyDigest` preview card on Today.
- Add "what changed since yesterday" micro-insight.

### Insights tab

- Ship `Coupled View` on iOS.
- Ship `Coupled View` on Android.
- Ship `Coupled View` on macOS.
- Add `InsightsHub` metric ranking drill-down.
- Add `Activity Cost` per-activity detail screen.
- Add lagged correlation selector (0–7 days) in `Compare`.
- Add `Compare` saved preset pairs.
- Add `Compare` annotations for events/workouts/journal.
- Add `Explore` anomaly highlight bands.
- Add `Explore` baseline overlay.
- Add `Explore` calendar heat-strip view.
- Add `Coach` follow-up suggestion chips.
- Add `Coach` prompt templates.
- Add `Insights` shareable image export.
- Add `Compare` shareable image export.
- Add `Explore` full-screen landscape chart on iPad.
- Add `Explore` full-screen landscape chart on Android tablets.
- Add `Explore` metric explorer search.
- Add `Insights` "since last change" narrative.

### Health tab

- Add `FitnessAge` card with confidence gate.
- Add `Vitality` / `Body Age` card.
- Add `VitalBands` personal-baseline band UI.
- Add `HRVFreqDomain` LF/HF chart card.
- Add `SpotHrvReading` on-demand spot HRV card.
- Add `StressIndex` Baevsky SI tile.
- Add `DaytimeStress` hourly heatmap.
- Add `StressOnsetDetector` guided-breath cue card.
- Add `SedentaryDetector` daily inactivity summary.
- Add `RhythmScreener` beat-regularity tile.
- Add `Workouts` list filter by sport/source.
- Add `Workouts` list merge/split actions.
- Add `Workouts` detail HR zone chart.
- Add `Workouts` detail calories methodology note.
- Add `Sleep` per-night notes/tags.
- Add `Sleep` manual edit with undo.
- Add `Sleep` deep-timeline sleep/workout markers.
- Add `Trends` shareable one-page PDF report.
- Add `Trends` compare multiple metrics overlay.
- Add `Trends` baseline confidence ribbons.
- Add `Live` full-screen heart-rate view.
- Add `Live` RR-interval tachogram.
- Add `Live` real-time HRV during session.
- Add `Breathe` session outcome pre/post comparison.
- Add `Breathe` custom inhale/exhale ratios.
- Add `Intervals` saved templates.
- Add `Lab Book` marker timeline in Health.
- Add `Rhythm` circadian phase estimate card.

### Sources tab

- Add `WHOOP CSV` import progress with ETA.
- Add `Apple Health export` streaming import progress.
- Add `Nutrition CSV` importer (Cronometer / MacroFactor) on iOS.
- Add `Nutrition CSV` importer (Cronometer / MacroFactor) on Android.
- Add `Oura` live ring import status.
- Add `Garmin` FIT/TCX import on iOS.
- Add `Garmin` FIT/TCX import on Android.
- Add `Xiaomi / Huami` QR-pair flow.
- Add `Backup & Sync` manual backup card.
- Add `Backup & Sync` auto background backup iOS.
- Add `Backup & Sync` auto background backup Android.
- Add `Backup & Sync` restore with conflict preview.
- Add `Data Sources` last-import per-source status.
- Add `Devices` battery history per strap.
- Add `Devices` rename strap (WHOOP 4.0 only).
- Add `Devices` firmware version history.
- Add `Devices` trusted/untrusted state.
- Add `Notifications` per-destination toggles.
- Add `Automations` Shortcuts list on iOS.
- Add `Smart Alarm` next-instance preview.
- Add `Test Centre` shortcut tile for active captures.

### Settings & app-wide

- Add profile waist-circumference field for `FitnessAge`.
- Add profile birth-sex field for analytics.
- Add profile max-HR override per sport.
- Add `What's new` changelog modal for new installs.
- Add settings export/import for all preferences.
- Add settings reset to defaults.
- Add opt-in crash/error log capture (local only).
- Add in-app language override.
- Add unit system preview in settings.
- Add display-mode dark/light/auto per platform.
- Add accessibility large-text support audit on iOS.
- Add accessibility large-text support audit on Android.
- Add VoiceOver labels for all chart elements on iOS.
- Add TalkBack labels for all chart elements on Android.
- Add keyboard navigation audit on macOS.
- Add haptics intensity setting.
- Add notification quiet-hours UI.
- Add experimental-feature gate list.
- Add debug-strap-log export from settings.
- Add privacy data-deletion confirmation flow.

### WHOOP 4.0 BLE

- Harden `MarginalRadioDetector` fallback to 0x2A37.
- Improve `PostBondTimeoutLoopDetector` re-pair messaging.
- Validate `EmptySyncTracker` clock-lost banner thresholds.
- Add `BackfillContinuation` progress UI.
- Add `RawOutbox` size quota warnings.
- Add `RawOutbox` manual prune action.
- Add `PuffinFrameRecorder` opt-in toggle on 4.0.
- Improve `Commands.swift` safe-command validation.
- Add `WhoopModel` auto-detection confidence score.
- Add strap LED identification command (if safe).
- Add `BATTERY_LEVEL` event low-battery local notification.
- Add `WRIST_ON` / `WRIST_OFF` automation triggers.
- Add `DOUBLE_TAP` action configuration on 4.0.
- Add `STRAP_DRIVEN_ALARM` set/get UI.
- Add `HAPTICS_FIRED` event log viewer.
- Improve historical offload ETA for 14-day backfill.
- Add `GET_CLOCK` drift alert UI.
- Add `SET_CLOCK` timezone/daylight-saving handling.
- Validate `SEND_R10_R11_REALTIME` raw-stream gating.
- Add live `REALTIME_RAW_DATA` type-43 visualiser.

### WHOOP 5.0 / MG BLE

- Decode `v18` historical full-sensor records reliably.
- Decode `v25` historical full-sensor records reliably.
- Decode `v26` 24 Hz PPG optical waveforms.
- Derive HR from `v26` PPG via autocorrelation (see `PpgHr.swift`).
- Integrate `v18` sleep-state byte into `SleepStager`.
- Integrate `v18` step counter + activity class into `StepsEstimateEngine`.
- Decode `fd4b0007` diagnostics channel.
- Harden `CLIENT_HELLO` bond handshake for reconnects.
- Add `R22` deep-data re-arm on every encrypted connect.
- Add `R22` deep-data status indicator in Live.
- Add `noopWhoop5DeepData` experiment gate.
- Add `noopContinuousHrv` live dense HR streaming.
- Add `noopContinuousHrvOvernightOnly` window gate.
- Add `noopBroadcastHr` advertising enable/disable.
- Add `noopPuffinExperiments` probe result viewer.
- Map puffin types 53/54/55/56 to canonical events.
- Add `METADATA` `HISTORY_COMPLETE` handling robustness.
- Add `PUFFIN_COMMAND/RESPONSE` type 37/38 decode.
- Add `RELATIVE_PUFFIN_EVENTS` handling.
- Add `WHOOP MG` ECG single-lead 250 Hz capture path.
- Add `WHOOP MG` pulse-arrival-time (PAT) blood-pressure estimate.
- Add `WHOOP 5` / `MG` rename capability if discovered.
- Add `WHOOP 5` battery pack console log decoding.
- Add `WHOOP 5` extended battery info tile.
- Add `WHOOP 5` memfault diagnostic log viewer.
- Add `WHOOP 5` raw IMU stream decoding (type 51).
- Add `WHOOP 5` historical IMU stream decoding (type 52).
- Validate `ContinuousHrvSchedule` quiet-hour windows.
- Harden `Whoop5EmptyOffloadTracker` messaging.

### Protocol decoding & `WhoopProtocol`

- Add schema-driven decode for new historical layout `v27+`.
- Add CRC validation fail-fast diagnostics.
- Add frame reassembly timeout logging.
- Add `whoop_protocol.json` schema validation CI test.
- Add unit tests for `Framing.swift` CRC8/CRC16/CRC32.
- Add unit tests for `Reassembler` fragmentation edge cases.
- Add unit tests for `Interpreter` family-aware offsets.
- Add unit tests for `Streams` skin-temperature conversion.
- Add unit tests for `HistoricalStreams` clock correction.
- Add unit tests for `PpgHr` autocorrelation on synthetic waveforms.
- Add unit tests for `Whoop5Config` R22 flag payload builder.
- Add property-based fuzz tests for frame parser.
- Document packet type 53/54 in `docs/PROTOCOL.md`.
- Document packet type 55/56 in `docs/PROTOCOL.md`.
- Document `v26` PPG layout in `docs/PROTOCOL.md`.
- Add protocol-change diff template for new firmware dumps.
- Add `fd4b0007` diagnostics format notes.
- Add `CLIENT_HELLO` variants per firmware.
- Add `PuffinExperiment` registry version field.
- Add protocol probe result upload helper (local file only).

### Persistence & `WhoopStore`

- Add schema migration smoke tests.
- Add `DatabaseIntegrity` quick-check CI step.
- Add `quarantineIncompatibleDatabase` recovery UI.
- Add `RawOutbox` size ceiling UI warning.
- Add `RawOutbox` one-tap prune to settings.
- Add `StreamStore` batch insert benchmarks.
- Add `Reads` `hrBuckets` downsampling tests.
- Add `Cursors` highwater reset safeguards.
- Add `MetricsCache` sleep-edit preservation tests.
- Add `LabMarkerStore` projection verification tests.
- Add `BackupSettings` round-trip tests.
- Add `TimestampHeal` idempotency tests.
- Add `SleepSessionDedup` overlap edge-case tests.
- Add `DismissedSleepSpans` tombstone cap handling.
- Add `DeviceRegistryStore` active-device invariant tests.
- Add `LiveSessionStore` recent-list query tests.
- Add `JournalWorkoutAppleCache` delete-and-rebuild tests.
- Add `MetricSeriesStore` range-read performance tests.
- Add `BackupSync` encrypted backup option.
- Add `BackupSync` per-device backup key.

### Sleep analytics (`StrandAnalytics`)

- Ship `SleepStagerV2` opt-in behind experiment gate.
- Validate `SleepStagerV2` on multi-subject nights.
- Add `SleepStager` nap vs main-sleep confidence.
- Improve `SleepStager` off-wrist backstop.
- Add `SleepStager` sparse-gravity bridge tuning.
- Add `SleepStager` REM-funnel diagnostic UI.
- Add `SleepStageTotals` learned-timing visualisation.
- Add `SleepWindowReclip` edit preview.
- Add `SleepDebt` cumulative chart.
- Add `SleepEditGuard` edit conflict resolution UI.
- Add `SleepReadout` HR-density chart.
- Add `SleepReadout` gravity-coverage chart.
- Add `AnalyticsEngine` per-session stage encoding tests.
- Add `SleepStager` daytime false-sleep guard tuning.
- Add `SleepStager` morning stillness guard rescue.
- Add `SleepStager` cold-start first-night handling.
- Add `SleepStager` multi-night baseline for habitual midsleep.
- Add `SleepStager` respiration regularity feature for REM.
- Add `SleepStager` HRV-derived sleep-onset marker.
- Add `SleepStager` HRV-derived wake marker.
- Add `SleepStager` calibration from user edits.
- Add `SleepStager` export/import of staging model.
- Add `SleepStager` side-by-side V1/V2 comparison.
- Add `SleepStager` confidence band per epoch.
- Add `SleepStager` wake-after-sleep-onset (WASO) drill-down.

### Recovery, strain & readiness (`StrandAnalytics`)

- Add `RecoveryScorer` per-term contribution chart.
- Add `RecoveryScorer` cold-start n-of-nights gate UI.
- Add `RecoveryForecast` evening card to Today.
- Add `RecoveryForecast` confidence band display.
- Add `ChargeDrivers` ordered list screen.
- Add `ReadinessEngine` per-signal flags UI.
- Add `ReadinessEngine` training-load balance chart.
- Add `StrainScorer` workout vs non-workout strain split.
- Add `StrainScorer` Banister vs Edwards toggle.
- Add `WorkoutDetector` sport classification from motion.
- Add `WorkoutDetector` GPS-less distance estimate.
- Add `WorkoutCalories` activity MET override.
- Add `WorkoutDetector` indoor vs outdoor hints.
- Add `WorkoutDetector` cooldown detection.
- Add `WorkoutDetector` merge candidate preview.
- Add `WatchRecovery` Apple Watch daily recovery card.
- Add `WatchRecovery` min-baseline explanation.
- Add `ScoreConfidence` downgrade explanation UI.
- Add `ScoreConfidence` H9 low-restorative check tests.
- Add `HRZones` manual zone overrides.

### HRV & vitals (`StrandAnalytics`)

- Add `HRVAnalyzer` cleaning trace viewer in Test Centre.
- Add `HRVAnalyzer` rolling RMSSD live chart.
- Add `HRVFreqDomain` LF/HF chart with span gates.
- Add `HRVFreqDomain` total power trend.
- Add `SpotHrvReading` UI for on-demand spot HRV.
- Add `SpotHrvReading` source caveat (optical vs chest strap).
- Add `SpotHrvReading` guided 1-minute measurement.
- Add continuous HRV from `v26` PPG HR.
- Add continuous HRV from dense type-40 live stream.
- Add `HRVAnalyzer` pNN50 tile.
- Add `HRVAnalyzer` SDNN trend tile.
- Add `HRVAnalyzer` meanNN trend tile.
- Add `HRVAnalyzer` ectopic fraction trend.
- Add `HRVAnalyzer` range-reject diagnostic.
- Add `HRVAnalyzer` Malik ectopic review.
- Add `HRVAnalyzer` min-beats gate explanation.
- Add `VitalBands` personal-baseline per vital.
- Add `VitalBands` population fallback note.
- Add `VitalBands` skin-temp mixed-semantics explanation.
- Add `VitalBands` SpO₂ population-only caveat.

### Health metrics (`StrandAnalytics`)

- Add `FitnessAgeEngine` result screen with confidence.
- Add `FitnessAgeEngine` waist-input gate.
- Add `FitnessAgeEngine` activity-index detail.
- Add `FitnessAgeEngine` VO₂max estimate display.
- Add `VitalityEngine` vitality score card.
- Add `VitalityEngine` body-age delta card.
- Add `VitalityEngine` input factor breakdown.
- Add `IllnessSignalEngine` Heads-Up card.
- Add `IllnessSignalEngine` confounder input tags.
- Add `IllnessDistance` Mahalanobis alternative view.
- Add `StressIndex` Baevsky SI chart.
- Add `DaytimeStress` hourly bar chart.
- Add `StressOnsetDetector` JITAI cue settings.
- Add `StressOnsetDetector` edge-trigger log.
- Add `SedentaryDetector` daily sedentary minutes tile.
- Add `SedentaryDetector` move reminder settings.
- Add `HydrationGoalEngine` daily goal card.
- Add `HydrationGoalEngine` climate/activity adjustment note.
- Add `StepsEstimateEngine` calibration UI.
- Add `StepsEstimateEngine` confidence tier display.
- Add `StepsEstimateEngine` WHOOP 5 raw counter path.
- Add `CircadianEngine` body-clock phase card.
- Add `CircadianEngine` jet-lag plan preview.

### Behaviour, insights & correlation (`StrandAnalytics`)

- Add `BehaviorInsights` narrative card on Today.
- Add `CorrelationEngine` two-metric scatter chart.
- Add `CorrelationEngine` lagged correlation selector.
- Add `CorrelationEngine` significance threshold note.
- Add `CorrelationEngine` saved correlations list.
- Add `DoseResponseEngine` dose-response curve UI.
- Add `FusionEngine` multi-sensor signal fusion UI.
- Add `WeeklyDigest` Monday-anchored week review screen.
- Add `WeeklyDigest` balance read (overreaching/underloaded).
- Add `WeeklyDigest` focal-point sentence cards.
- Add `WeeklyDigest` week-over-week comparison chart.
- Add `ActivityInsights` per-activity recovery impact list.
- Add `BehaviorInsights` tag-based journal correlation.
- Add `CorrelationEngine` outlier exclusion toggle.
- Add `CorrelationEngine` baseline-adjusted correlation.
- Add `WeeklyDigest` shareable summary image.
- Add `WeeklyDigest` Monday notification.
- Add `BehaviorInsights` trend-change detection.
- Add `ActivityCost` per-activity average strain.
- Add `ActivityCost` recovery half-life estimate.

### Data import & sources

- Add WHOOP CSV `physiological_cycles.csv` import tests.
- Add WHOOP CSV `sleeps.csv` import tests.
- Add WHOOP CSV `workouts.csv` import tests.
- Add WHOOP CSV `journal_entries.csv` import tests.
- Add Apple Health `export.xml` streaming tests.
- Add Apple Health sleep-stage mapping tests.
- Add Nutrition CSV Cronometer importer.
- Add Nutrition CSV MacroFactor importer.
- Add Oura live ring auth challenge flow.
- Add Oura API token-less historical dump import.
- Add Garmin FIT parser for HR/R-R.
- Add Garmin TCX parser for workouts.
- Add Xiaomi/Huami custom service discovery.
- Add Polar/Wahoo/Coospo standard HR source UI.
- Add FTMS treadmill source tile.
- Add FTMS bike source tile.
- Add FTMS rower source tile.
- Add FTMS cross-trainer source tile.
- Add `HrBroadcaster` re-broadcast toggle.
- Add `SourceCoordinator` multi-device switcher.

### watchOS & Apple Watch

- Add watchOS complication for recovery ring.
- Add watchOS complication for live HR.
- Add watchOS app `NOOPWatchApp.swift` standalone status.
- Add watchOS manual sleep start/end action.
- Add watchOS haptic breathe session.
- Add watchOS interval timer.
- Add Apple Watch live-HR fallback source.
- Add Apple Watch `WatchRecovery` daily sync.
- Add watchOS battery tile.
- Add watchOS last-sync tile.

### Widgets & Live Activities

- Add iOS small Today widget.
- Add iOS medium Today widget.
- Add iOS large Today widget.
- Add iOS live activity for active workout.
- Add iOS live activity for live HR.
- Add iOS live activity for breathe session.
- Add iOS Lock Screen widget for live HR.
- Add iOS StandBy widget for recovery.
- Add Android Today widget 1x1.
- Add Android Today widget 2x1.
- Add Android Today widget 4x1.
- Add Android 14+ live update widget for live HR.
- Add Android glanceable tile for recovery.
- Add macOS Notification Center Today widget.
- Add macOS menu bar live HR popover graph.
- Add widget snapshot refresh on sync completion.
- Add widget configuration intents.
- Add widget per-metric selection.
- Add widget dark/light palette.
- Add widget preview assets.

### iOS-specific

- Add iOS onboarding `What's new` modal.
- Add iOS HealthKit write opt-in flow.
- Add iOS `Export for Shortcuts` intent expansion.
- Add iOS Shortcuts `Get today's recovery` action.
- Add iOS Shortcuts `Get last workout` action.
- Add iOS background-refresh for live HR.
- Add iOS background fetch for strap history.
- Add iOS local notification delivery for smart alarm.
- Add iOS App Intents for `Live`, `Breathe`, `Intervals`.
- Add iOS critical battery notification.
- Add iOS `Live Activity` start from Control Centre.
- Add iOS iPad sidebar layout.
- Add iOS iPad multi-column `Insights` layout.
- Add iOS accessibility dynamic type audit.
- Add iOS TestFlight/F-Droid-style distribution notes.
- Add iOS free signing identity limitations doc.
- Add iOS AltStore source auto-update test.
- Add iOS `.ipa` re-sign helper script.
- Add iOS beta crash log capture (opt-in).
- Add iOS in-app review request (never intrusive).

### Android-specific

- Add Android onboarding `What's new` modal.
- Add Android Health Connect write support.
- Add Android Health Connect read support.
- Add Android background sync for strap history.
- Add Android foreground service for live HR.
- Add Android notification channel for strap status.
- Add Android local notification for smart alarm.
- Add Android app shortcuts for `Live`, `Breathe`.
- Add Android Wear OS companion tile.
- Add Android tablet two-pane layout.
- Add Android dynamic colour theme support.
- Add Android per-app language override.
- Add Android backup/restore with encrypted `.noopbak`.
- Add Android APK signature reproducibility notes.
- Add Android Gradle build cache in CI.
- Add Android lint baseline cleanup.
- Add Android unit-test coverage report.
- Add Android screenshot tests for Compose.
- Add Android baseline profile for startup.
- Add Android edge-to-edge layout audit.

### macOS-specific

- Add macOS menu bar heart-rate graph.
- Add macOS menu bar recovery badge.
- Add macOS keyboard shortcuts for all tabs.
- Add macOS `Command + N` new window.
- Add macOS multiple window support.
- Add macOS Touch Bar controls for `Live`/`Breathe`.
- Add macOS automation Shortcuts actions list.
- Add macOS ` Automations` double-tap action picker.
- Add macOS inactivity reminder menu bar toggle.
- Add macOS smart alarm menu bar countdown.
- Add macOS quick-settings dropdown.
- Add macOS status bar sync spinner.
- Add macOS full-screen `Live` view.
- Add macOS `Today` widget for Notification Center.
- Add macOS `Support` screen with system info copy.
- Add macOS `Privacy` permission diagnostics.
- Add macOS notarization-free first-launch FAQ.
- Add macOS homebrew cask formula.
- Add macOS disk-image (.dmg) release artifact.
- Add macOS auto-update Sparkle-style check.

### AI Coach

- Add `AICoach` local model endpoint support.
- Add `AICoach` prompt template library.
- Add `AICoach` follow-up context limit display.
- Add `AICoach` per-question metric attachment picker.
- Add `AICoach` suggested questions from current trends.
- Add `AICoach` plain-language insight summaries.
- Add `AICoach` privacy note before first use.
- Add `AICoach` token usage estimate.
- Add `AICoach` response share action.
- Add `AICoach` model-list refresh race fix.
- Add `AICoach` local/remote endpoint toggle.
- Add `AIProvider` error retry with backoff.
- Add `AIProvider` streaming response UI.
- Add `AICoach` markdown rendering for answers.
- Add `AICoach` source citation for cited metrics.
- Add `AICoach` multi-turn conversation history.
- Add `AICoach` delete conversation.
- Add `AICoach` export conversation (local file).
- Add `AICoach` prompt-injection mitigation review.
- Add `AICoach` rate-limit UI.

### Test Centre & diagnostics

- Add `TestModeRegistry` per-mode description screen.
- Add `TestCentreLayout` priority ordering tests.
- Add `UniversalTrace` clock-drift chart.
- Add `Spo2ReTrace` raw PPG hex export.
- Add `ConnectionTrace` reconnect cycle log.
- Add `BatteryTrace` per-cycle voltage trend.
- Add `SleepTrace` staging gate verdict list.
- Add `HRVTrace` cleaning step breakdown.
- Add `StepsTrace` calibration ratio scatter.
- Add `RawFrameRecorder` start/stop UI.
- Add `TestCentre` export log zip.
- Add `TestCentre` per-domain GitHub label helper.
- Add `TestCentre` capture countdown UI.
- Add `TestCentre` guided capture questionnaire.
- Add `TestCentre` battery test mode.
- Add `TestCentre` recovery test mode.
- Add `TestCentre` hrv test mode.
- Add `TestCentre` steps test mode.
- Add `TestCentre` data-import test mode.
- Add `TestCentre` display test mode.

### CI, build & release

- Add CI job for `swift test` in each package.
- Add CI job for `xcodebuild test` on macOS app.
- Add CI job for Android unit tests.
- Add CI job for Android lint.
- Add CI job for `CHANGELOG.md` / `AppChangelog` parity.
- Add CI job for `altstore-source.json` schema validation.
- Add CI job for release-notes file existence.
- Add CI build cache for XcodeGen derived data.
- Add CI build cache for Gradle.
- Add CI Apple signing with ephemeral certs.
- Add CI reproducible `.apk` signing.
- Add CI automatic AltStore source update.
- Add CI automatic docs release-notes copy.
- Add CI Slack/Discord release notification.
- Add CI nightly `main` smoke build.
- Add CI dependency vulnerability scan (SCA).
- Add CI license header check.
- Add CI markdown link check.
- Add CI secrets scanning.
- Add CI static analysis for Swift (SwiftLint/SwiftFormat).

### Documentation & marketing

- Update `docs/ARCHITECTURE.md` with v5 hub diagram.
- Update `docs/PROTOCOL.md` with 5.0/MG packet types.
- Update `docs/BLE_REVERSE_ENGINEERING.md` with v26 notes.
- Update `docs/IOS.md` with AltStore/source instructions.
- Update `docs/ANDROID.md` with sideload/Health Connect notes.
- Update `docs/ANALYTICS.md` with every analyzer formula.
- Update `docs/FAQ.md` with 5/MG pairing FAQ.
- Add `docs/WATCHOS.md` setup guide.
- Add `docs/WIDGETS.md` platform widget guide.
- Add `docs/COACH.md` AI Coach privacy/setup guide.
- Add `docs/PRIVACY_SECURITY.md` data-flow diagram.
- Add `docs/CONTRIBUTING.md` issue/PR template guide.
- Add `docs/releases/v9.1.0.md` draft.
- Add `docs/releases/v9.2.0.md` draft.
- Add marketing demo video for Strand hubs.
- Add marketing screenshots for all three platforms.
- Add marketing feature matrix graphic.
- Add README Roadmap section (this section).
- Add README badges for build/test status.
- Add star-history CTA.

### Community, legal & governance

- Add `CODE_OF_CONDUCT.md` enforcement contact.
- Add `SECURITY.md` vulnerability reporting process.
- Add `SUPPORT.md` tiered support expectations.
- Add `CONTRIBUTING.md` translation guide.
- Add `CONTRIBUTING.md` analytics parity checklist.
- Add `CONTRIBUTING.md` BLE protocol documentation checklist.
- Add issue templates for bug/ feature/ protocol.
- Add PR template with test/release checklist.
- Add stale issue bot with protocol-research exempt label.
- Add GitHub Discussions for Q&A.
- Add Discord webhook for releases.
- Add Reddit release post template.
- Add mastodon/Bluesky release post template.
- Add project governance note (maintainer + core contributors).
- Add trademark use guidelines for "NOOP" / "WHOOP".
- Add license compatibility matrix for dependencies.
- Add archive request process note.
- Add donation/support link (GitHub Sponsors / Ko-fi).
- Add contributor hall of fame.
- Add no-cloud privacy pledge in README.

## Activity

A live snapshot of the last 30 days — issues, pull requests, pushes, and the people moving NOOP
forward. Huge thanks to everyone filing reports, sharing strap logs, and reverse-engineering the
protocol alongside us — this project is built on it.

<p>
  <img alt="Open issues" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdskja%2Fnoop%2Fmain%2Fdocs%2Fstats%2Fopen.json&style=flat-square">
  <img alt="Issues resolved" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdskja%2Fnoop%2Fmain%2Fdocs%2Fstats%2Fresolved.json&style=flat-square">
  <a href="https://github.com/dskja/noop/stargazers"><img alt="Stars" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdskja%2Fnoop%2Fmain%2Fdocs%2Fstats%2Fstars.json&style=flat-square"></a>
  <img alt="Forks" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdskja%2Fnoop%2Fmain%2Fdocs%2Fstats%2Fforks.json&style=flat-square">
  <img alt="Commits per month" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdskja%2Fnoop%2Fmain%2Fdocs%2Fstats%2Flastcommit.json&style=flat-square">
  <img alt="Last commit" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdskja%2Fnoop%2Fmain%2Fdocs%2Fstats%2Flastcommit.json&style=flat-square">
</p>

![Repobeats analytics image](https://repobeats.axiom.co/api/embed/97acba228c083adca8453a1ebf15f18dad2894be.svg "Repobeats analytics image")

### Star history

If NOOP's useful to you, a ⭐ genuinely helps it reach more WHOOP users — and it's the single best free way to support the project.

[![Star History Chart](https://api.star-history.com/svg?repos=dskja/noop&type=Date)](https://star-history.com/#dskja/noop&Date)
