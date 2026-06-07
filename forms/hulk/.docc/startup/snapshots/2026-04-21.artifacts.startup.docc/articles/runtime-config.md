# runtime-config

Settings read by the Claude Code runtime before any context is injected. These files govern which other surfaces get loaded (autoMemoryDirectory, permissions, voice).

### ✓ `private/universal/substrate/harnesses/hulk/settings.json`
366 bytes · ~91 tok

```json
{
  "permissions": {
    "defaultMode": "dontAsk"
  },
  "statusLine": {
    "type": "command",
    "command": "sh ~/.claude/statusline-command.sh"
  },
  "autoUpdatesChannel": "latest",
  "voiceEnabled": true,
  "voice": {
    "enabled": true,
    "mode": "hold"
  },
  "autoMemoryDirectory": "~/.claude/memory/.docc",
  "skipDangerousModePermissionPrompt": true
}
```

**Phase total**: ~91 tok