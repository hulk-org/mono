---
name: three-artifacts-per-ported-scene-capture-canonical-emission
description: "When the substrate ports an external web aesthetic, the workflow produces THREE distinct artifacts — Capture (verbatim input), Swift+Metal Canonical (substrate-native primary form), and Substrate-Emitted Web (substrate's own re-rendering back on web) — and the \"web sibling\" of a Swift port is the EMISSION, not the capture"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4607cead-e19a-4212-a0f1-2d9ebfd83c24
---

The substrate's scene-porting workflow's POINT is to **close a loop**:
take a website's aesthetic, port it to Swift (substrate-native canonical
form), then ALSO be able to render that same aesthetic on the web from
the substrate's own form.

**Operator's exact words (2026-06-04, after I had authored a "web
sibling" that was the verbatim captured Three.js):**
> the point of these work session is to take a website, take it's main
> aesthetic, make it swift, then be able to do that on the web too.

**Three artifacts per ported scene — distinguished by INTENT:**

1. **Capture** — verbatim input from the original creator's website
   (HTML / JS / GLSL extracted by the web-browser app's snapshot).
   Preserved as INPUT REFERENCE so the substrate can compare its
   re-rendering against the source. Creator attribution + verbatim
   license required.

2. **Swift+Metal Canonical** — substrate-native primary form. Hand-port
   (or eventually digikoma-transpile-emitted) renderer that becomes the
   canonical substrate representation of the aesthetic. Lives as a
   per-Package SPM module at
   `laussat-studio/private/apple/desktop-scenes/<slug>/`. Creator
   attribution preserved in source-comment headers.

3. **Substrate-Emitted Web** — substrate's RE-RENDERING of the same
   canonical form back onto the web. Substrate-authored Three.js /
   WebGL / WebGPU scaffolding that uses substrate-shaped APIs (typed
   parameter structs, named renderer classes mirroring the Swift form,
   typed lifecycle methods). May reuse the verbatim GLSL shader (the
   shader IS the aesthetic), but the JS scaffolding is substrate-style,
   not verbatim from the capture. Lives as a sibling at
   `clia-org/private/universal/web-scenes/<slug>/web-emission/`.

**What this rules out:**

- Calling the verbatim captured Three.js the "web sibling" of the Swift
  port. That's the CAPTURE, not the substrate's web emission.
- Authoring a substrate-typed scene without producing the substrate's
  own web re-rendering. The loop is open until emission lands.
- Treating the captured JS as the substrate's permanent web rendering.
  The capture is an input reference; the emission is the actual peer
  of the Swift port.

**Directory shape per scene (refines per-scene-independent-spm-packages):**

```
clia-org/private/universal/web-scenes/<slug>/
  README.md                       (umbrella, explains both arms)
  capture/                        (verbatim input)
    <slug>.scene.json             (tags include "intent:capture", "verbatim")
    <slug>.js                     (verbatim from snapshot)
    <slug>.frag.glsl / .vert.glsl
    index.html
    LICENSE.txt
    README.md
  web-emission/                   (substrate-emitted)
    <slug>.scene.json             (tags include "intent:substrate-emission")
    <SlugPascalCase>Renderer.js   (substrate-shaped class — mirrors Swift renderer)
    <SlugPascalCase>Parameters.js (substrate-typed defaults — mirrors Swift struct)
    <slug>.frag.glsl / .vert.glsl (verbatim copy of shader; aesthetic is the shader)
    index.html                    (substrate-shaped preview hosting the renderer)
    LICENSE.txt                   (Sabo Sugi MIT — the shader is his)
    README.md
```

**The 10 wrkstrm-original motifs** don't have a Capture (no source
website), but they DO need:
- Swift+Metal Canonical (extracted from desktop-studio into per-Package
  at laussat-studio).
- Substrate-Emitted Web (substrate-authored Three.js mirroring the
  Swift form back onto the web).

**Cross-references:**

- [[per-scene-independent-spm-packages]] — each scene's Package is the
  unit; this refines the Package's internal subdir shape.
- [[copy-don't-overwrite-when-versioning]] — moving the verbatim
  capture into a `capture/` subdir is a structural relocation, not an
  overwrite; the substrate-emitted version is a NEW sibling, not a
  v0.2.0 of the capture.
- [[credit-our-creators-even-in-closed-source]] — every artifact
  carries verbatim attribution.
- [[Backends are peers not versions]] — Swift+Metal and
  Substrate-Emitted Web are first-class peers, joined by sceneSlug
  typed disk refs.
- [[content-lives-in-its-owners-home]] — Swift+Metal at Laussat,
  capture + substrate-emitted web at clia-org.

**How to apply going forward:**

1. Any operator ask "port this pen" / "make this Swift" / "we need a
   scene from X" decomposes into the THREE artifacts above.
2. The workflow is not "done" until the substrate-emitted web arm
   lands, not just the Swift+Metal arm.
3. For substrate-original scenes (no capture), only arms 2 + 3 apply.
