---
name: form-folder-arms-private-universal-apple
description: Form (and broadly substrate-home) folders use the private/universal + private/apple arm convention — cross-platform content under universal in kura-typed homes; Apple-restricted under private/apple.
metadata: 
  node_type: memory
  type: feedback
  originSessionId: c5a791f0-7c27-4647-986a-a89122fc8571
---

**Form folders (and substrate homes generally) use the `private/universal/` + `private/apple/` arm convention.** Operator-stated 2026-05-30 during ghost-form hosting clarification.

For a form like `agents/<host>/forms/<form-slug>/`, the contents subdivide:

```
agents/<host>/forms/<form>/
  form.json                  ← FormModel instance
  identity/                  ← form-specific identity bundle
  private/
    universal/               ← cross-platform private content
      kura/
        collections/<typed-collection>/  ← anything portable goes in kura-typed home
    apple/                   ← Apple-restricted (Xcode/iOS/macOS/Swift Package bundles)
```

**Why:**
- **`private/` arm** = restricted/private to this home (not public)
- **`private/universal/`** = cross-platform content (portable across runtime targets). MUST live in proper kura-typed collection homes, not free-form. Operator: "in the universal arm: anything that can work everywhere in the right kura space."
- **`private/apple/`** = Apple-restricted content (Xcode projects, iOS/macOS-specific artifacts, Swift Package fixtures, Apple-platform binaries)

**How to apply:**
- When authoring a new form (`agents/<host>/forms/<form>/`), DON'T dump files into the form root. Place them in the right arm:
  - Cross-platform identity/state/manifests → `private/universal/<kura-collection>/`
  - LoRA adapters / model weights (when typed home exists) → `private/universal/kura/collections/<adapter-collection>/` (modulo 100 MB git limit; LFS or external storage for large blobs)
  - Apple-platform-specific artifacts (Xcode projects, framework bundles, .xcconfig) → `private/apple/`
- This convention applies to forms, agents, operators, collectives — any substrate home that needs both platform-restricted and portable content.
- The `private/universal/` arm is NOT a free-for-all dumping ground: content must live in proper kura-typed collections so it's discoverable by tree traversal and addressable by LinkRef.

Composes with [[feedback_content-lives-in-its-owners-home]] (the home concept) + [[feedback_kura-public-vs-private-placement]] (kura placement rules) + [[feedback_form-is-universal-binding-pattern]] (forms apply across organism kinds; each form follows this folder convention).

Triggers for retrieval: any time authoring inside a form folder, an agent home, or any substrate-owned home that needs to handle both cross-platform and platform-restricted content.
