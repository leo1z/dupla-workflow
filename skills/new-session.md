Start work session. Read state, define next steps.

Usage: /new-session [optional goal]

---

## Execution

1. **Check YAML header** in docs/PROJECT_STATE.md:
   - Extract: `status: CURRENT | DRAFT | STALE`
   - If STALE → ⚠️ "Estado marcado como STALE. ¿Verificar? [s/n]"
     - If yes → read git log -10 and reconstruct SESSION from reality

2. **Read <session> block** (first content after header):
   - Extract: Updated, Done, Next, Blockers, Branch, Model
   - Compute staleness: "Updated" vs now
   - If Updated > 24h OR git log is newer → auto-reconstruct from git log (silent, then show updated SESSION)

3. **If planning** → read docs/ROADMAP.md (5 min)

4. **If building** → read docs/ARCHITECTURE.md (5 min)

5. **If debugging** → read docs/PROBLEMS.md (5 min)

6. **Do NOT read all files.** Load only what the session requires.

7. Show 3 most recent save points from git log (via /restore data):
```
Save points recientes:
  5 · hace 2h   → "Agrega validación"
  4 · hace 4h   → "Conecta auth"
  3 · ayer 3pm  → "Setup inicial"
```

---

## Output (max 12 lines)

```
## Session — [date]

**Goal:** [from user arg / inferred from Next / ask if missing]
**Branch:** [current] [⚠️ si está en main]
**LLM:** [from Model field in SESSION, or Claude]

**State:** [1–2 lines from SESSION Done + Next combined]

**Plan:**
1. [concrete step]
2. [concrete step]
3. [if needed]

**Alert:** [if blocker exists / on main / state stale / conflict]
```

---

## Decision Logic

| Condition | Action |
|-----------|--------|
| No goal provided | Ask in 1 line: "¿Cuál es el objetivo de esta sesión?" |
| Next field is clear | Don't ask goal — use Next as direction |
| SESSION > 24h OR git log newer | Auto-reconstruct from git log (no prompt) |
| status: STALE | Warn before continuing |
| Blockers field ≠ "none" | Highlight in Alert |
| On main branch | ⚠️ Strong warning |
| git status has conflicts | Block, don't continue |

---

## Rules

- Max 12 lines. No filler.
- Trust SESSION block first, git log second
- If PROJECT_STATE is newer than commits → use PROJECT_STATE
- If git log is newer → git log wins (suggest /checkpoint to update PROJECT_STATE)
- Never require previous /checkpoint — infer from git
- Show next 3 save points as reference (don't force restore)
