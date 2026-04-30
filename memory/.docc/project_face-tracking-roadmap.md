---
name: Face tracking roadmap
description: Capability tiers for clia-app-org's face-tracking pipeline; clia-face is the test bench, port to clia-sprite once stable
type: project
originSessionId: d3e69688-4a13-4c12-bc6a-64890afc82de
---
The on-device face-tracking engine `clia-app/src/headtrack.{h,mm}` is shared between `clia-face` (SDL+GL avatar window) and `clia-sprite` (gaze-cursor status app). Capability tiers + adoption order are documented at `private/universal/substrate/collectives/clia-app-org/private/apple/apps/.docc/face-tracking-tiers.md` and linked from the apps `.docc/index.md`.

**Why:** Both apps consume the same engine, so adding a Vision capability in one place lights it up in both. The doc tiers what's free today (`VNDetectFaceRectangles`), what's a one-line swap (`VNDetectFaceLandmarks` → blink, mouth-open, real eye direction, roll/yaw/pitch), what's a sibling Vision request (body/hand pose, optical flow, fast tracker), and what's pure derived signal on top of landmarks. Anchors honest expectations about Vision's limits (on-device only, no identity, ~30fps for landmarks, glasses degrade detection).

**How to apply:** Adoption order is **clia-face first, clia-sprite second**. clia-face has the SDL+GL renderer + listener.mm — richer visual feedback for testing landmarks, blink, mouth-open animation than Sprite's small overlay. Once a Tier 2 signal is verified end-to-end in clia-face (green LED, smooth 30fps, no Vision error spam, demo looks right), port the upgraded `headtrack.{h,mm}` to clia-sprite and surface via the Character system. When the API stabilizes, graduate `headtrack` to a shared SwiftPM library at `clia-app/Sources/HeadTrackKit/` so the file-copy duplication ends.
