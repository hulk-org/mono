---
name: same-shape-same-model
description: Two struct types with identical field shape are ONE model with two property-name uses, not two types — semantic distinction lives on the parent property name and inline comments, never as a duplicate type definition.
type: feedback
originSessionId: a82fce5b-517e-4e09-87fe-07f1c2aea15e
---
If two structs have the same field shape (same field names + same field
types, modulo a kind/parameter enum), they are **one model used twice**, not
two models. The semantic distinction lives on the parent's property name and
the inline comment that explains intent, never as duplicate type definitions.

**Why:** Curry-Howard discipline — a type is a proposition. Two types with
the same shape are the same proposition; giving them different names creates
two literals of the same theorem and lies to the compiler about how many
distinct constraints the schema enforces. The user has been explicit: "if a
model has the same type shape as another, it's not 2 models: it's 1 model
with a different name / semantics which is what the property name and
inline comments are for."

**How to apply:**
- When proposing a new struct, check whether an existing struct already has
  this shape. If yes, reuse it — even if the *use site* is conceptually
  different. Distinguish on the parent property name, not the type name.
- A generic `Foo<Kind>` that takes a kind enum parameter is the canonical
  way to express "same shape, different value sets." Prefer this over
  `FooA + FooB` where the only difference is the kind enum type.
- Inline comments on parent property declarations carry semantic differentiation:
  ```swift
  /// Receipt destination — where receipts land per run.
  public var receiptDestination: WorkflowKindedPath<ReceiptKind>
  /// Writeback destination — where state mutations flow back.
  public var writebackDestination: WorkflowKindedPath<WritebackKind>
  ```
- "Almost same shape" doesn't trigger this rule — if Struct A has an extra
  domain-specific field (e.g., `WorkflowExecutionTarget.entrypoint`) that
  Struct B doesn't have, they are different models. The rule is for
  *exactly identical* field signatures.
- This is structural deduplication, not interface deduplication — protocols
  with the same requirements are a separate question (and the SwiftUI-
  protocol-pattern memory covers extensibility surfaces).
