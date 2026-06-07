// 2026-05-28 - Materialize child gate sets for spawn-software.
//
// WHAT: Writes gate-set JSON files beside the spawn-software child and leaf
//       workstream templates in wrkstrm Kura.
//
// WHY: The parent spawn-software graph had a gate set, but child workstreams
//      only named reviewGates inside templates. This scratchpad makes those
//      gates judgeable artifacts without hand-writing repeated JSON.
//
// Usage:
//   swift run --package-path private/universal/substrate/agents/claude/memory/.docc/repl-proofs \
//     spawn-gate-set-materializer-2026-05-28 --root /Users/sonoma/mono

import Foundation

struct GateSet: Encodable {
  var name: String
  var schemaVersion: String = "0.1.0"
  var gateSetVersion: String = "0.1.0"
  var description: String
  var gates: [Gate]
}

struct Gate: Encodable {
  var gateId: String
  var stage: String
  var title: String
  var blocking: Bool = true
  var requiredArtifacts: [String]
  var judgeSlugs: [String]?
  var approvalRoles: [String]?
  var failureDisposition: String
}

struct GateSetPlan {
  var relativePath: String
  var gateSet: GateSet
}

@main
struct SpawnGateSetMaterializer {
  static func main() throws {
    let root = argument("--root") ?? FileManager.default.currentDirectoryPath
    let rootURL = URL(fileURLWithPath: root).standardizedFileURL
    let plans = gateSetPlans()

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

    for plan in plans {
      let url = rootURL.appendingPathComponent(plan.relativePath)
      try FileManager.default.createDirectory(
        at: url.deletingLastPathComponent(),
        withIntermediateDirectories: true
      )
      var data = try encoder.encode(plan.gateSet)
      data.append(0x0A)
      try data.write(to: url, options: [.atomic])
      print("wrote \(plan.relativePath)")
    }

    print("done: \(plans.count) child gate sets")
  }

  static func argument(_ name: String) -> String? {
    let args = Array(CommandLine.arguments.dropFirst())
    guard let index = args.firstIndex(of: name), index + 1 < args.count else {
      return nil
    }
    return args[index + 1]
  }

  static func gateSetPlans() -> [GateSetPlan] {
    let base = "private/universal/substrate/collectives/wrkstrm/private/universal/kura/spaces/workstreams/collections/spawn-software"

    func plan(_ relativeDirectory: String, _ gateSet: GateSet) -> GateSetPlan {
      GateSetPlan(
        relativePath: "\(base)/\(relativeDirectory)/\(gateSet.name).gate-set.json",
        gateSet: gateSet
      )
    }

    return [
      plan("sub-workstreams/launch-software", GateSet(
        name: "launch-software",
        description: "Child gate set for the request-to-release lane inside spawn-software.",
        gates: [
          gate("design-truth-complete", "software-design", "Design truth is complete", [
            "design-truth-packet",
            "implementation-ready-design-packet",
          ], "stay-inside-software-design-until-product-audience-journey-role-ux-ui-uxw-and-surface-truth-exist"),
          gate("implementation-surface-present", "software-implementation", "Implementation surface is present", [
            "implemented-software-surface",
            "source-code-and-config",
            "build-artifacts",
          ], "stay-inside-software-implementation-until-the-designed-surface-is-inspectable"),
          gate("qa-evidence-complete", "software-qa", "QA evidence is complete", [
            "qa-evidence-packet",
            "verification-evidence-packet",
            "launch-review-ready-verdict",
          ], "stay-inside-software-qa-until-verification-evidence-and-defect-triage-are-complete"),
          launchDecisionGate(),
          gate("maintenance-handoff-recorded", "release-and-maintenance-handoff", "Maintenance handoff is recorded", [
            "maintenance-handoff-packet",
            "initial-monitoring-obligations",
          ], "do-not-close-launch-software-until-maintenance-ownership-and-initial-obligations-are-recorded"),
        ]
      )),

      plan("sub-workstreams/launch-software/sub-workstreams/software-design", GateSet(
        name: "software-design",
        description: "Parent design gate set that assembles product, audience, requirement, journey, role, UX, UI, UXW, and surface truth before implementation.",
        gates: [
          gate("product-brief-complete", "product-brief", "Product brief is complete", [
            "product-brief",
            "promise-statement",
            "anti-scope-list",
          ], "return-to-product-brief-until-promise-scope-and-anti-scope-are-explicit"),
          gate("target-demographic-specific", "target-demographic", "Target demographic is specific", [
            "target-demographic-packet",
            "audience-constraints",
            "excluded-audiences",
          ], "return-to-target-demographic-until-core-user-constraints-and-exclusions-are-visible"),
          gate("prd-and-cuj-coherent", "prd-and-cuj", "PRD and CUJ are coherent", [
            "product-requirements-document",
            "requirement-inventory",
            "critical-user-journeys",
            "journey-success-criteria",
            "journey-failure-modes",
          ], "repair-requirements-or-journeys-until-acceptance-truth-and-user-paths-agree"),
          gate("role-boundaries-explicit", "role-design", "Role boundaries are explicit", [
            "role-descriptions",
            "approval-boundaries",
            "role-interaction-map",
          ], "return-to-role-design-until-responsibilities-approvals-and-interactions-are-legible"),
          gate("ux-ui-uxw-ready", "ux-ui-uxw-design", "UX, UI, and UXW are ready", [
            "ux-flow-set",
            "ui-surface-direction",
            "uxw-language-guidance",
            "error-and-recovery-flows",
            "warning-and-prompt-inventory",
          ], "return-to-design-lanes-until-flows-surfaces-and-language-guidance-are-bounded"),
          gate("tools-and-surfaces-definition-ready", "tools-and-surfaces-definition", "Tools and surfaces definition is ready", [
            "tools-and-surfaces-definition",
            "surface-inventory",
            "explicit-open-questions-list",
          ], "stay-inside-tools-and-surfaces-definition-until-buildable-surfaces-and-open-questions-are-explicit"),
          gate("implementation-ready-design-packet-present", "handoff", "Implementation-ready design packet is present", [
            "implementation-ready-design-packet",
            "audience-and-journey-truth",
            "surface-inventory",
          ], "do-not-handoff-to-implementation-until-design-truth-is-packaged"),
        ]
      )),

      plan("sub-workstreams/launch-software/sub-workstreams/software-design/sub-workstreams/product-brief", GateSet(
        name: "product-brief",
        description: "Leaf gate set for framing the product promise, scope, and anti-scope.",
        gates: [
          gate("product-promise-explicit", "frame-promise", "Product promise is explicit", [
            "promise-statement",
            "product-brief",
          ], "do-not-advance-until-the-product-promise-is-legible"),
          gate("scope-bounded", "bound-scope", "Scope is bounded", [
            "product-brief",
            "open-product-questions",
          ], "keep-bounding-scope-until-the-brief-names-what-is-in-and-unknown"),
          gate("anti-scope-recorded", "state-anti-scope", "Anti-scope is recorded", [
            "anti-scope-list",
          ], "record-what-this-product-will-not-do-before-handoff"),
        ]
      )),

      plan("sub-workstreams/launch-software/sub-workstreams/software-design/sub-workstreams/target-demographic", GateSet(
        name: "target-demographic",
        description: "Leaf gate set for making the audience specific enough to design for.",
        gates: [
          gate("core-user-explicit", "define-core-user", "Core user is explicit", [
            "target-demographic-packet",
          ], "do-not-advance-until-the-core-user-is-named"),
          gate("constraints-recorded", "record-constraints-and-exclusions", "Audience constraints are recorded", [
            "audience-constraints",
          ], "record-audience-constraints-before-the-packet-handoff"),
          gate("exclusions-visible", "record-constraints-and-exclusions", "Audience exclusions are visible", [
            "excluded-audiences",
            "adjacent-audience-notes",
          ], "record-excluded-and-adjacent-audiences-before-the-packet-handoff"),
        ]
      )),

      plan("sub-workstreams/launch-software/sub-workstreams/software-design/sub-workstreams/prd", GateSet(
        name: "prd",
        description: "Leaf gate set for requirements, acceptance truth, and constraints.",
        gates: [
          gate("requirements-explicit", "define-requirements", "Requirements are explicit", [
            "product-requirements-document",
            "requirement-inventory",
          ], "do-not-advance-until-requirements-are-enumerated"),
          gate("acceptance-truth-recorded", "record-acceptance-and-constraints", "Acceptance truth is recorded", [
            "acceptance-constraints",
          ], "record-acceptance-truth-before-handoff"),
          gate("constraints-bounded", "record-acceptance-and-constraints", "Constraints are bounded", [
            "acceptance-constraints",
            "product-requirements-document",
          ], "bound-requirement-constraints-before-handoff"),
        ]
      )),

      plan("sub-workstreams/launch-software/sub-workstreams/software-design/sub-workstreams/cuj", GateSet(
        name: "cuj",
        description: "Leaf gate set for critical user journeys and their success/failure conditions.",
        gates: [
          gate("critical-journeys-explicit", "define-critical-journeys", "Critical journeys are explicit", [
            "critical-user-journeys",
          ], "do-not-advance-until-critical-journeys-are-enumerated"),
          gate("success-criteria-recorded", "record-success-and-failure-conditions", "Journey success criteria are recorded", [
            "journey-success-criteria",
          ], "record-success-criteria-before-handoff"),
          gate("failure-modes-visible", "record-success-and-failure-conditions", "Journey failure modes are visible", [
            "journey-failure-modes",
          ], "record-failure-modes-before-handoff"),
        ]
      )),

      plan("sub-workstreams/launch-software/sub-workstreams/software-design/sub-workstreams/role-design", GateSet(
        name: "role-design",
        description: "Leaf gate set for software-facing roles, approvals, and interaction boundaries.",
        gates: [
          gate("roles-explicit", "define-roles", "Roles are explicit", [
            "role-descriptions",
          ], "do-not-advance-until-roles-are-named"),
          gate("approval-boundaries-recorded", "record-approval-and-interaction-boundaries", "Approval boundaries are recorded", [
            "approval-boundaries",
          ], "record-approval-boundaries-before-handoff"),
          gate("role-interactions-visible", "record-approval-and-interaction-boundaries", "Role interactions are visible", [
            "role-interaction-map",
          ], "record-role-interactions-before-handoff"),
        ]
      )),

      plan("sub-workstreams/launch-software/sub-workstreams/software-design/sub-workstreams/ux-design", GateSet(
        name: "ux-design",
        description: "Leaf gate set for interaction flows and recovery paths.",
        gates: [
          gate("core-flows-explicit", "define-interaction-flows", "Core flows are explicit", [
            "ux-flow-set",
            "interaction-sequence-map",
          ], "do-not-advance-until-core-interaction-flows-are-named"),
          gate("recovery-paths-recorded", "record-recovery-paths", "Recovery paths are recorded", [
            "error-and-recovery-flows",
          ], "record-error-and-recovery-paths-before-handoff"),
          gate("ux-flow-set-bounded", "handoff-ux-flow-set", "UX flow set is bounded", [
            "ux-flow-set",
          ], "bound-the-flow-set-before-design-handoff"),
        ]
      )),

      plan("sub-workstreams/launch-software/sub-workstreams/software-design/sub-workstreams/ui-design", GateSet(
        name: "ui-design",
        description: "Leaf gate set for surface inventory, hierarchy, and UI direction.",
        gates: [
          gate("surface-inventory-explicit", "define-surface-inventory", "Surface inventory is explicit", [
            "surface-inventory",
          ], "do-not-advance-until-surfaces-are-inventoried"),
          gate("hierarchy-recorded", "record-layout-and-hierarchy", "Layout and hierarchy are recorded", [
            "layout-and-hierarchy-notes",
          ], "record-layout-and-hierarchy-before-handoff"),
          gate("ui-direction-bounded", "handoff-ui-direction", "UI direction is bounded", [
            "ui-surface-direction",
          ], "bound-ui-direction-before-design-handoff"),
        ]
      )),

      plan("sub-workstreams/launch-software/sub-workstreams/software-design/sub-workstreams/uxw-design", GateSet(
        name: "uxw-design",
        description: "Leaf gate set for language, trust posture, warnings, prompts, and explanations.",
        gates: [
          gate("language-guidance-explicit", "define-language-and-trust-posture", "Language guidance is explicit", [
            "uxw-language-guidance",
          ], "do-not-advance-until-product-language-guidance-is-explicit"),
          gate("trust-posture-recorded", "define-language-and-trust-posture", "Trust posture is recorded", [
            "trust-posture-notes",
          ], "record-trust-posture-before-handoff"),
          gate("warning-and-prompt-inventory-present", "record-warnings-prompts-and-explanations", "Warning and prompt inventory is present", [
            "warning-and-prompt-inventory",
          ], "record-warnings-prompts-and-explanations-before-handoff"),
        ]
      )),

      plan("sub-workstreams/launch-software/sub-workstreams/software-design/sub-workstreams/tools-and-surfaces-definition", GateSet(
        name: "tools-and-surfaces-definition",
        description: "Leaf gate set for translating design truth into buildable tools and surfaces.",
        gates: [
          gate("tools-and-surfaces-definition-ready", "define-tools-and-surfaces", "Tools and surfaces definition is ready", [
            "tools-and-surfaces-definition",
            "surface-inventory",
          ], "do-not-advance-until-tools-and-surfaces-are-buildable"),
          gate("open-questions-recorded", "record-open-questions", "Open questions are recorded", [
            "explicit-open-questions-list",
          ], "record-open-questions-before-implementation-handoff"),
          gate("implementation-ready-design-packet-present", "handoff-implementation-ready-design-packet", "Implementation-ready design packet is present", [
            "implementation-ready-design-packet",
          ], "do-not-handoff-until-the-implementation-ready-packet-exists"),
        ]
      )),

      plan("sub-workstreams/launch-software/sub-workstreams/software-implementation", GateSet(
        name: "software-implementation",
        description: "Child gate set for proving design truth in code and concrete surfaces.",
        gates: [
          gate("design-traceability-present", "intake-design-packet", "Design traceability is present", [
            "implementation-ready-design-packet",
          ], "do-not-build-against-unsourced-design-truth"),
          gate("build-artifacts-inspectable", "prepare-release-artifacts", "Build artifacts are inspectable", [
            "working-software-surface",
            "source-code-and-config",
            "build-artifacts",
          ], "keep-implementation-open-until-built-surfaces-and-artifacts-can-be-inspected"),
          gate("known-risks-recorded", "prepare-release-artifacts", "Known risks are recorded", [
            "implementation-notes-and-known-risks",
            "implementation-risk-notes",
          ], "record-known-risks-before-qa-handoff"),
          gate("qa-ready-packet-present", "handoff-to-qa", "QA-ready packet is present", [
            "qa-ready-implementation-packet",
            "release-artifact-candidates",
          ], "do-not-handoff-to-qa-without-an-inspectable-qa-ready-packet"),
        ]
      )),

      plan("sub-workstreams/launch-software/sub-workstreams/software-qa", GateSet(
        name: "software-qa",
        description: "Child gate set for mapping acceptance criteria, verifying implementation, and assembling launch-review evidence.",
        gates: [
          gate("requirement-traceability-present", "map-acceptance-criteria", "Requirement traceability is present", [
            "product-requirements-document",
            "critical-user-journeys",
            "qa-plan",
          ], "do-not-run-verification-without-requirement-and-journey-traceability"),
          gate("verification-evidence-complete", "run-verification-passes", "Verification evidence is complete", [
            "verification-evidence-packet",
            "qa-evidence-packet",
          ], "continue-verification-until-evidence-is-complete"),
          gate("blocking-defects-triaged", "route-defects-or-assemble-evidence-packet", "Blocking defects are triaged", [
            "defect-list",
            "blocking-defects-list",
          ], "triage-blocking-defects-before-launch-review-handoff"),
          gate("launch-review-ready-verdict-recorded", "handoff-to-software-launch-review", "Launch-review-ready verdict is recorded", [
            "launch-review-ready-verdict",
          ], "do-not-handoff-to-launch-review-without-an-explicit-verdict"),
        ]
      )),

      plan("sub-workstreams/launch-software/sub-workstreams/software-launch-review", GateSet(
        name: "software-launch-review",
        description: "Child gate set for final release-boundary review inside launch-software.",
        gates: [
          launchReadinessGate("release-packet-complete", "open-release-packet", "Release packet is complete", [
            "software-launch-review-packet",
            "release-manifest",
            "release-pass",
          ], "repair-release-packet-before-review"),
          launchReadinessGate("qa-evidence-present", "inspect-implementation-and-qa-evidence", "QA evidence is present", [
            "qa-evidence-packet",
            "verification-evidence-packet",
          ], "return-to-qa-until-release-facing-evidence-is-present"),
          launchReadinessGate("audience-facing-claims-inspectable", "inspect-audience-facing-surfaces", "Audience-facing claims are inspectable", [
            "target-demographic-packet",
            "critical-user-journeys",
            "implemented-software-surface",
            "human-visual-verification",
          ], "repair-audience-facing-surface-evidence-before-decision"),
          Gate(
            gateId: "explicit-decision-recorded",
            stage: "record-decision",
            title: "Explicit decision is recorded",
            requiredArtifacts: [
              "approved-or-blocked-decision",
              "software-launch-review-decision",
              "release-writeback",
            ],
            judgeSlugs: ["spawn-launch-readiness-judge"],
            approvalRoles: [
              "launch-review-engineering-approver",
              "launch-review-audience-approver",
              "launch-review-director",
            ],
            failureDisposition: "do-not-cross-release-boundary-without-an-explicit-decision"
          ),
        ]
      )),

      plan("sub-workstreams/maintain-software", GateSet(
        name: "maintain-software",
        description: "Child gate set for live stewardship, repair, pivot, sunset, and residual obligation capture.",
        gates: [
          gate("signal-triaged", "triage", "Signal is triaged", [
            "live-service-signal-packet",
            "triaged-operating-evidence",
          ], "do-not-choose-maintenance-mode-until-the-live-signal-is-triaged"),
          gate("chosen-maintenance-mode-explicit", "preserve-fix-pivot-or-sunset", "Chosen maintenance mode is explicit", [
            "maintenance-decision",
            "repair-or-pivot-artifact",
          ], "record-preserve-fix-pivot-or-sunset-mode-before-repair-motion"),
          gate("updated-operating-context-present", "update-context-and-obligations", "Updated operating context is present", [
            "updated-operating-context",
            "updated-service-context",
          ], "update-operating-context-before-closing-maintenance-work"),
          gate("residual-obligations-recorded", "update-context-and-obligations", "Residual obligations are recorded", [
            "residual-obligations-inventory",
            "follow-on-maintenance-obligations",
          ], "record-residual-obligations-before-returning-to-monitoring"),
        ]
      )),

      plan("sub-workstreams/maintain-software/sub-workstreams/software-monitoring", GateSet(
        name: "software-monitoring",
        description: "Leaf gate set for observing live software, triaging signals, and routing follow-on work.",
        gates: [
          gate("monitoring-coverage-present", "observe-live-surface", "Monitoring coverage is present", [
            "monitoring-posture-packet",
            "monitoring-signal-packet",
          ], "do-not-call-the-surface-observable-until-coverage-is-present"),
          gate("signals-triaged", "triage-signal", "Signals are triaged", [
            "triaged-operating-evidence",
            "maintenance-trigger-or-redesign-signal",
          ], "triage-live-signals-before-routing-maintenance-or-redesign"),
          gate("follow-on-obligations-recorded", "record-evidence-and-obligations", "Follow-on obligations are recorded", [
            "updated-monitoring-posture",
            "monitoring-posture-update",
            "maintenance-trigger",
            "redesign-signal",
          ], "record-monitoring-updates-and-follow-on-obligations-before-handoff"),
        ]
      )),
    ]
  }

  static func gate(
    _ gateId: String,
    _ stage: String,
    _ title: String,
    _ artifacts: [String],
    _ failureDisposition: String,
    judgeSlugs: [String] = ["spawn-evidence-coverage-judge"]
  ) -> Gate {
    Gate(
      gateId: gateId,
      stage: stage,
      title: title,
      requiredArtifacts: artifacts,
      judgeSlugs: judgeSlugs,
      failureDisposition: failureDisposition
    )
  }

  static func launchReadinessGate(
    _ gateId: String,
    _ stage: String,
    _ title: String,
    _ artifacts: [String],
    _ failureDisposition: String
  ) -> Gate {
    gate(
      gateId,
      stage,
      title,
      artifacts,
      failureDisposition,
      judgeSlugs: ["spawn-launch-readiness-judge"]
    )
  }

  static func launchDecisionGate() -> Gate {
    Gate(
      gateId: "software-launch-review-approved",
      stage: "software-launch-review",
      title: "Software Launch Review is approved",
      requiredArtifacts: [
        "software-launch-review-decision",
        "approved-release-packet",
        "release-decision-trail",
      ],
      judgeSlugs: ["spawn-launch-readiness-judge"],
      approvalRoles: [
        "launch-review-engineering-approver",
        "launch-review-audience-approver",
        "launch-review-director",
      ],
      failureDisposition: "route-back-for-changes-or-replan-release"
    )
  }
}
