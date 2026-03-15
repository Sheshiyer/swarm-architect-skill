# Pairing Swarm Architect with Impeccable

Use this guide when you want **Swarm Architect** to handle orchestration and **impeccable** to strengthen the quality bar for frontend and UI work.

## Core Split
- **Swarm Architect** decides the execution structure: phases, waves, swarms, ownership, dependencies, GitHub sync, and validation gates.
- **Impeccable** improves the **frontend design process** inside relevant swarms by providing stronger review vocabulary, anti-pattern detection, and polish commands.

Think of it as:
- Swarm Architect = **delivery orchestration**
- Impeccable = **frontend quality methodology**

## Where Impeccable Fits Best
Impeccable is most useful in swarms that own:
- UI implementation
- design system refinement
- responsive cleanup
- interaction polish
- pre-release frontend hardening

It is not a replacement for backend planning, issue graphs, or multi-agent dependency control.

## Command-to-Wave Mapping

| Impeccable method | Best Swarm Architect checkpoint |
|---|---|
| `/audit` | validation gate before merge |
| `/critique` | design review swarm or pre-implementation review |
| `/normalize` | design-system alignment pass |
| `/polish` | final UI hardening before release |
| `/distill` | simplification pass when interfaces become cluttered |
| `/clarify` | UX-writing and messaging cleanup |
| `/harden` | edge-case and resilience pass |
| anti-pattern lists | acceptance criteria for UI tasks |

## Suggested Operating Pattern

### 1. Contract wave
Define the UI boundaries and expected user flows.

### 2. UI build wave
Let Codex or the selected UI agent implement the feature.

### 3. Impeccable review pass
Run an impeccable-style review overlay before merge:
- audit visual hierarchy
- check anti-patterns
- improve motion and copy if needed
- simplify cluttered interfaces

### 4. Validation wave
Let Gemini or your validation agent verify the polished UI against acceptance criteria.

## Suggested Schema Extension
You can attach a methodology overlay to a UI task.

```json
{
  "id": "T-051",
  "owner_agent": "codex",
  "quality_profile": "impeccable/polish",
  "validation_profile": "gemini/regression"
}
```

## Example Pairing

| Concern | Runtime owner | Methodology overlay |
|---|---|---|
| Checkout page build | Codex | `impeccable/critique` + `impeccable/polish` |
| Design-system cleanup | Codex or Claude | `impeccable/normalize` |
| Launch-readiness review | Gemini + Claude | `impeccable/audit` |

## Best Practice
Use impeccable as a **quality layer**, not as the orchestration layer.
It should refine how frontend work is evaluated and improved, while Swarm Architect continues to control ownership, sequencing, and integration boundaries.
