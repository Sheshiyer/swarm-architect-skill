# First-Run Bootstrap

Use this bootstrap flow to prepare Swarm Architect for memory-aware execution with:
- **OpenViking** as the memory plane
- **agency-agents** as optional specialist execution overlays
- **impeccable** as optional frontend quality overlays

## What bootstrap does
Bootstrap is a **setup layer**, not a live runtime adapter.

It helps you:
- clone upstream profile repos once,
- prepare OpenViking config if needed,
- generate deterministic memory path conventions for the current repo,
- and keep local setup artifacts out of git.

## Files involved
- `.swarm-bootstrap.example.json` → example config
- `.swarm-bootstrap.json` → your local config (ignored by git)
- `.swarm-openviking-paths.json` → generated memory path registry (ignored by git)
- `scripts/bootstrap-upstreams.sh` → clone-once upstream setup
- `scripts/bootstrap-openviking.sh` → OpenViking preparation and path generation

## Recommended first run

```bash
cp .swarm-bootstrap.example.json .swarm-bootstrap.json
./scripts/bootstrap-upstreams.sh
./scripts/bootstrap-openviking.sh
```

## Clone-once behavior
The bootstrap scripts are idempotent:
- if `.external/agency-agents` already exists, it is not recloned
- if `.external/impeccable` already exists, it is not recloned
- if OpenViking config already exists, it is not overwritten unless you choose to edit it

## OpenViking modes
The config supports:
- `local` → use a local OpenViking config file and local install
- `remote` → keep OpenViking remote and only generate path conventions locally
- `disabled` → skip OpenViking setup while preserving Swarm Architect planning features

## Generated memory paths
The OpenViking bootstrap script generates a deterministic path registry for the current repo, including patterns for:
- planning memory
- phase memory
- wave memory
- swarm memory
- task memory
- validation memory

This gives every task and wave a predictable `viking://` home.

## What bootstrap does not do yet
This bootstrap layer does **not yet**:
- ingest upstream repos into OpenViking automatically
- write task memory during execution automatically
- act as a live memory plugin/adapter

Those belong to the next integration phase.
