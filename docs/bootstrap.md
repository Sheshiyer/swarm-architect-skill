# First-Run Bootstrap

Use this bootstrap flow to prepare Swarm Architect for memory-aware execution with:
- **OpenViking** as the memory plane
- **agency-agents** as optional specialist execution overlays
- **impeccable** as optional frontend quality overlays

## What bootstrap does
Bootstrap is a **setup layer**.

It helps you:
- clone upstream profile repos once,
- prepare OpenViking config if needed,
- generate deterministic memory path conventions for the current repo,
- generate an upstream resource registry,
- and keep local setup artifacts out of git.

## Files involved
- `.swarm-bootstrap.example.json` → example config
- `.swarm-bootstrap.json` → your local config (ignored by git)
- `.swarm-upstream-resources.json` → generated upstream registry for OpenViking ingestion (ignored by git)
- `.swarm-openviking-paths.json` → generated memory path registry (ignored by git)
- `scripts/bootstrap-upstreams.sh` → clone-once upstream setup + upstream resource registry generation
- `scripts/bootstrap-openviking.sh` → OpenViking preparation and path generation
- `scripts/index-openviking-resources.sh` → optional OpenViking ingestion for discovered upstream resources

## Recommended first run

```bash
cp .swarm-bootstrap.example.json .swarm-bootstrap.json
./scripts/bootstrap-upstreams.sh
./scripts/bootstrap-openviking.sh
./scripts/index-openviking-resources.sh --dry-run
./scripts/index-openviking-resources.sh --wait
```

## Clone-once behavior
The bootstrap scripts are idempotent:
- if `.external/agency-agents` already exists, it is not recloned
- if `.external/impeccable` already exists, it is not recloned
- if OpenViking config already exists, it is not overwritten unless you choose to edit it

Run `bootstrap-upstreams.sh` first when you want upstream repos to become visible in the generated OpenViking path registry. It emits `.swarm-upstream-resources.json`, which `bootstrap-openviking.sh` folds into `.swarm-openviking-paths.json`, and which `index-openviking-resources.sh` consumes for actual resource ingestion.

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

## Indexing resources into OpenViking
The new indexing script performs the actual resource ingestion step using the OpenViking CLI.

### Prerequisites
- OpenViking server configured and reachable
- CLI configured via `~/.openviking/ovcli.conf` or `OPENVIKING_CLI_CONFIG_FILE`
- `openviking` installed locally (some environments may provide `ov` as an alias)

### Dry-run first

```bash
./scripts/index-openviking-resources.sh --dry-run
```

### Execute ingestion

```bash
./scripts/index-openviking-resources.sh --wait
```

### Replace existing indexed resources

```bash
./scripts/index-openviking-resources.sh --replace-existing --wait
```

### Limit indexing to one upstream

```bash
./scripts/index-openviking-resources.sh --only agency-agents --wait
```

## What remains out of scope
This bootstrap + indexing layer now prepares and ingests upstream repos into OpenViking resources, but it still does **not yet**:
- write task memory during execution automatically
- act as a live runtime plugin/adapter
- commit memory records on behalf of worker agents automatically

Those belong to the next runtime integration phase.
