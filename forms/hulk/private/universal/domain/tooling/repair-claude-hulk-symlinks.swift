#!/usr/bin/env swift

import Foundation

struct SymlinkRepair {
    let path: String
    let target: String
}

let repairs: [SymlinkRepair] = [
    .init(
        path: "private/universal/substrate/agents/claude/forms/hulk/projects",
        target: "../../../../../kura-spaces/ai/exports/anthropic/claude/projects"
    ),
    .init(
        path: "private/universal/substrate/agents/claude/forms/hulk/archived_sessions",
        target: "../../../../../kura-spaces/ai/exports/anthropic/claude/sessions/archived_sessions"
    ),
    .init(
        path: "private/universal/substrate/agents/claude/forms/hulk/sessions",
        target: "../../../../../kura-spaces/ai/exports/anthropic/claude/sessions/current"
    ),
    .init(
        path: "private/universal/substrate/agents/claude/forms/hulk/skills",
        target: "../../../../skills"
    ),
    .init(
        path: "private/universal/substrate/agents/claude/forms/hulk/agents/claude",
        target: "../../../../../agents/claude"
    ),
]

let fileManager = FileManager.default
let repoRoot = fileManager.currentDirectoryPath

func resolvedPath(for symlinkPath: String, target: String) -> String {
    let absoluteSymlinkPath = URL(fileURLWithPath: symlinkPath, relativeTo: URL(fileURLWithPath: repoRoot)).path
    let parent = URL(fileURLWithPath: absoluteSymlinkPath).deletingLastPathComponent()
    return URL(fileURLWithPath: target, relativeTo: parent).standardizedFileURL.path
}

for repair in repairs {
    let absolutePath = URL(fileURLWithPath: repair.path, relativeTo: URL(fileURLWithPath: repoRoot)).path
    let destination = resolvedPath(for: repair.path, target: repair.target)
    guard fileManager.fileExists(atPath: destination) else {
        fputs("error: target does not exist for \(repair.path): \(destination)\n", stderr)
        exit(1)
    }

    do {
        if let currentTarget = try? fileManager.destinationOfSymbolicLink(atPath: absolutePath) {
            if currentTarget == repair.target {
                print("ok: \(repair.path) already points to \(repair.target)")
                continue
            }

            try fileManager.removeItem(atPath: absolutePath)
        }

        if fileManager.fileExists(atPath: absolutePath) {
            try fileManager.removeItem(atPath: absolutePath)
        }

        try fileManager.createSymbolicLink(atPath: absolutePath, withDestinationPath: repair.target)
        print("fixed: \(repair.path) -> \(repair.target)")
    } catch {
        fputs("error: failed to repair \(repair.path): \(error)\n", stderr)
        exit(1)
    }
}
