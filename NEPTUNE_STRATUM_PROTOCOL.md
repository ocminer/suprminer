# Neptune Stratum Protocol Specification

**Version:** 2.0  
**Date:** 2025-12-11  
**Consensus:** HardforkAlpha  
**For:** Pool operators and miner developers

---

## TABLE OF CONTENTS

1. [Overview](#overview)
2. [Connection Flow](#connection-flow)
3. [Stratum Messages](#stratum-messages)
4. [Nonce Construction](#nonce-construction)
5. [Job Structure](#job-structure)
6. [Share Submission](#share-submission)
7. [Algorithm Differences (NPT vs XNT)](#algorithm-differences-npt-vs-xnt)
8. [Guesser Buffer Management](#guesser-buffer-management)
9. [Data Formats](#data-formats)
10. [Implementation Notes](#implementation-notes)

---

## OVERVIEW

Neptune uses a modified Stratum protocol for pool mining. This document specifies the exact message formats, data sizes, and byte ordering required for miner/pool communication.

**Key Characteristics:**
- JSON-RPC over TCP, newline-delimited
- Extended 192-bit nonce space (extranonce1 + extranonce2 + nonce)
- Tip5 hash algorithm (not SHA256)
- 40-byte digests (5 × u64 BFieldElements)
- Two coin variants: NPT (mainnet) and XNT (testnet) with different parameters

---

## CONNECTION FLOW

```
1. TCP Connect to pool:port
2. mining.subscribe → extranonce1, extranonce2_size
3. mining.authorize → true/false
4. mining.set_difficulty ← difficulty
5. [Wait for work - may receive "no_work_available" status]
6. mining.notify ← job data
7. [Mine...]
8. mining.submit → accepted/rejected
9. [Repeat from step 5 or 6]
```

**CRITICAL:** Each JSON message must end with `\n` (newline).

---

## STRATUM MESSAGES

### 1. mining.subscribe

**Purpose:** Register with pool, receive extranonce1 assignment.

**Request:**
```json
{
  "id": 1,
  "method": "mining.subscribe",
  "params": ["miner-name/version"]
}
```

**Response:**
```json
{
  "id": 1,
  "result": [
    null,
    "f8f35e5f00000001",
    8
  ],
  "error": null
}
```

**Response Fields:**

| Index | Field | Type | Description |
|-------|-------|------|-------------|
| [0] | session_id | null/string | Optional session identifier (can be ignored) |
| [1] | extranonce1 | string | **16 hex chars** (8 bytes) - Pool-assigned unique identifier |
| [2] | extranonce2_size | number | **8** - Size of extranonce2 in bytes |

**IMPORTANT:**
- `extranonce1` is **16 hex characters** (8 bytes / 64-bit)
- `extranonce2_size` is **8 bytes** (64-bit)
- Total extranonce space: 16 bytes (128-bit)

---

### 2. mining.authorize

**Purpose:** Authenticate worker with pool.

**Request:**
```json
{
  "id": 2,
  "method": "mining.authorize",
  "params": ["username.worker", "password"]
}
```

**Response:**
```json
{
  "id": 2,
  "result": true,
  "error": null
}
```

---

### 3. mining.set_difficulty

**Purpose:** Pool sets share difficulty (vardiff).

**Notification (from pool):**
```json
{
  "id": null,
  "method": "mining.set_difficulty",
  "params": [420000]
}
```

**Fields:**
- `params[0]`: Pool difficulty as decimal number

---

### 4. mining.notify (Job Notification)

**Purpose:** Pool sends new work to miner.

#### 4a. Normal Work Notification

**Notification (from pool):**
```json
{
  "id": 0,
  "jsonrpc": "2.0",
  "result": {
    "id": 0,
    "job": {
      "id": "job_12345",
      "proposal_id": "212f9e9563bbcda8a402cbbe4918befaa46155a9a128f41b75fe784b9f72dd770001cf582f18c1cb",
      "difficulty": "420000",
      "threshold": "1590f0b31addec78ea66d0d2085f7a57a7920232fc04041b2f44dd2ca9c441cb8ee7547201290000",
      "parent_digest": "390b1856007192018e88354287c71de2d8c8ffed92f0e8c8ce92b40a461716a31817aae9bf100000",
      "paths": {
        "pow": [
          "80fc0d2524d5e9e05cd8df1332af3288ed82952ed08ec75f6526118335313bb7ad71858a7bcc6946",
          "44671a2949ed67f251604fa11de52ddf1e020eb25acc5dfec19d0b92bd16ec11f84dd02bbe0f29e6",
          "6d36cfa3d5890b40950342ed4d6fa0708bdcf1486bde371563840fcb438016de1989af3871ff1aa6"
        ],
        "header": [
          "2453ec299792afc052f2506dc9ff94bb2a4d3e1ba45768d8a1dcff8ee5f1b62d9097f3a727596070",
          "51631781b3594a3b3326f0383431591e9819d72b394ce42968ea299eb2d7bf882d1394ccbbab8d82"
        ],
        "kernel": [
          "84600ed67e27d71f11ceac5bee217a634793ea672682677f6dcfeefd0012100599edd80d29c6cd0b"
        ]
      }
    }
  }
}
```

**Job Fields:**

| Field | Type | Size | Description |
|-------|------|------|-------------|
| `id` | string | variable | Job identifier for share submission |
| `proposal_id` | hex string | 80 chars (40 bytes) | Block proposal identifier |
| `difficulty` | string | decimal | Pool difficulty (vardiff) |
| `threshold` | hex string | 80 chars (40 bytes) | Network threshold (5 BFieldElements) |
| `parent_digest` | hex string | 80 chars (40 bytes) | Previous block digest (HardforkAlpha) |
| `paths.pow` | array | 3 × 80 hex | Authentication paths for PoW |
| `paths.header` | array | 2 × 80 hex | Authentication paths for header |
| `paths.kernel` | array | 1 × 80 hex | Authentication paths for kernel |

**CRITICAL:**
- All digests are **80 hex characters** (40 bytes = 5 × u64)
- All u64 values are **little-endian** encoded
- `parent_digest` is used for guesser buffer construction (NPT/HardforkAlpha)

#### 4b. No Work Available Notification

When the pool has no work available (e.g., node is preprocessing a new block, or block was just found), it sends a special notification:

**Notification (from pool):**
```json
{
  "id": null,
  "method": "mining.notify",
  "params": {
    "status": "no_work_available",
    "message": "Node preprocessing - please wait..."
  }
}
```

**Miner Behavior:**
1. Stop current mining operations
2. Display status message to user
3. Wait for next `mining.notify` with actual work
4. Do NOT disconnect - connection remains active
5. Resume mining when work arrives

**Common "No Work" Scenarios:**
- Block just found, node preprocessing next block
- Node syncing with network
- Node starting up / initializing
- Temporary network issues

---

### 5. mining.submit (Share Submission)

**Purpose:** Miner submits found share to pool.

**Request:**
```json
{
  "id": 3,
  "method": "mining.submit",
  "params": [
    "username.worker",
    "job_12345",
    "0000000000000000",
    "00000000",
    "00000000000001fd",
    "165655ac726ecaf16c188b85269dee3422c4af11fe4e8e873744189e2d4e8644f3c08604501c3ffe",
    ["path_a_0_hex", "path_a_1_hex", "..."],
    ["path_b_0_hex", "path_b_1_hex", "..."]
  ]
}
```

**Submit Parameters:**

| Index | Field | Type | Size | Description |
|-------|-------|------|------|-------------|
| [0] | worker | string | variable | Worker name |
| [1] | job_id | string | variable | Job ID from mining.notify |
| [2] | extranonce2 | hex string | **16 chars** (8 bytes) | Miner's extranonce2 value |
| [3] | _reserved | hex string | 8 chars (4 bytes) | Reserved field (use "00000000") |
| [4] | nonce | hex string | **16 chars** (8 bytes) | Nonce that found the share |
| [5] | root | hex string | 80 chars (40 bytes) | Guesser buffer merkle root |
| [6] | path_a | array | N × 80 hex | Merkle path for index_a (N = tree_height) |
| [7] | path_b | array | N × 80 hex | Merkle path for index_b (N = tree_height) |

**Path Array Size:**
- NPT: 29 elements (tree_height = 29)
- XNT: 27 elements (tree_height = 27)

**Response (Accepted):**
```json
{
  "id": 3,
  "result": true,
  "error": null
}
```

**Response (Rejected):**
```json
{
  "id": 3,
  "result": null,
  "error": [21, "low difficulty share", null]
}
```

---

## NONCE CONSTRUCTION

### Nonce Space Layout

Neptune uses a 192-bit (24 byte) nonce input space:

```
┌─────────────────┬─────────────────┬─────────────────┐
│   extranonce1   │   extranonce2   │     nonce       │
│    8 bytes      │    8 bytes      │    8 bytes      │
│   (from pool)   │ (miner counter) │ (miner iterate) │
└─────────────────┴─────────────────┴─────────────────┘
         ↓                 ↓                 ↓
         └─────────────────┴─────────────────┘
                           │
                    24 bytes input
                           │
                           ↓
                   ┌───────────────┐
                   │  Tip5 Hash    │
                   └───────────────┘
                           │
                           ↓
                  40 bytes nonce_digest
                  (5 × BFieldElement)
```

### Size Summary

| Component | Bytes | Hex Chars | Range |
|-----------|-------|-----------|-------|
| extranonce1 | 8 | 16 | 0 - 2^64-1 (pool assigned) |
| extranonce2 | 8 | 16 | 0 - 2^64-1 (miner increments) |
| nonce | 8 | 16 | 0 - 2^64-1 (miner iterates) |
| **Total Input** | **24** | **48** | 192-bit search space |
| **nonce_digest** | **40** | **80** | Tip5 hash output |

### Construction Algorithm

```c
// Step 1: Parse hex strings to u64 (big-endian hex interpretation)
uint64_t ex1 = parse_hex_u64(extranonce1_hex);  // "f8f35e5f00000001" → 0xf8f35e5f00000001
uint64_t ex2 = parse_hex_u64(extranonce2_hex);  // "0000000000000000" → 0x0000000000000000
uint64_t nonce = nonce_value;                    // 0x00000000000001fd

// Step 2: Concatenate as little-endian bytes (24 bytes total)
uint8_t buffer[24];
memcpy(&buffer[0],  &ex1,   8);  // ex1 as little-endian bytes
memcpy(&buffer[8],  &ex2,   8);  // ex2 as little-endian bytes
memcpy(&buffer[16], &nonce, 8);  // nonce as little-endian bytes

// Step 3: Hash with Tip5
uint8_t nonce_digest[40] = Tip5_hash_bytes(buffer, 24);
```

### Example

```
extranonce1:  "9636d38100000000" (hex)
extranonce2:  "0000000000000000" (hex)  
nonce:        0x0001d9fd (u64)

As u64 values:
  ex1   = 0x9636d38100000000
  ex2   = 0x0000000000000000
  nonce = 0x00000000001d9fd

Buffer (24 bytes, little-endian):
  [00 00 00 00 81 d3 36 96]  ← ex1 as LE bytes
  [00 00 00 00 00 00 00 00]  ← ex2 as LE bytes  
  [fd d9 01 00 00 00 00 00]  ← nonce as LE bytes

Tip5 hash → nonce_digest (40 bytes)
```

---

## JOB STRUCTURE

### Digest Format

All Neptune digests are 5 × u64 BFieldElements:

| Property | Value |
|----------|-------|
| Size | 40 bytes |
| Hex representation | 80 characters |
| Structure | 5 × u64 (little-endian) |
| Field modulus | 2^64 - 2^32 + 1 |

**Parsing Example:**
```
Hex string: "390b1856007192018e88354287c71de2d8c8ffed92f0e8c8ce92b40a461716a31817aae9bf100000"

Split into 5 × 16-char chunks, each interpreted as little-endian u64:
  bytes[0:7]   → u64[0] = 0x0192710056180b39
  bytes[8:15]  → u64[1] = 0xe21dc7874235888e
  bytes[16:23] → u64[2] = 0xc8e8f092edffc8d8
  bytes[24:31] → u64[3] = 0xa3161746a0b492ce
  bytes[32:39] → u64[4] = 0x000010bfe9aa1718
```

### Commitment Calculation

The commitment uniquely identifies a job and is calculated from the authentication paths:

```
commitment = Tip5_hash_varlen(
    pow[0] || pow[1] || pow[2] || 
    header[0] || header[1] || 
    kernel[0]
)
```

**Input:** 6 digests × 40 bytes = 240 bytes  
**Output:** 40 bytes (5 BFieldElements)

---

## ALGORITHM DIFFERENCES (NPT vs XNT)

Neptune has two coin variants with different Proof-of-Work parameters:

| Parameter | NPT (Mainnet) | XNT (Testnet) |
|-----------|---------------|---------------|
| Tree Height | **29** | **27** |
| Number of Leaves | 2^29 = 536,870,912 | 2^27 = 134,217,728 |
| Budding Rounds | **1** | **32** |
| Bud Prefix | parent_digest | commitment |
| Alpha Swap | Yes (HardforkAlpha) | No (skip) |
| Memory Required | ~20 GB | ~5 GB |
| Path Length | 29 digests | 27 digests |

### Guesser Buffer Construction

The guesser buffer is a large Merkle tree built during preprocessing. The key differences:

#### NPT (Mainnet)
```
bud_prefix = parent_digest
budding_rounds = 1
skip_alpha_swap = false

For each leaf i in [0, 2^29):
    bud[i] = Tip5_hash(parent_digest || i)   // Single hash
    
// Apply bitreverse swap (HardforkAlpha)
// Build Merkle tree
```

#### XNT (Testnet)
```
bud_prefix = commitment
budding_rounds = 32
skip_alpha_swap = true

For each leaf i in [0, 2^27):
    bud = Tip5_hash(commitment || i)
    for round in [0, 32):
        bud = Tip5_hash(bud)                  // 32 iterations
    leaf[i] = bud
    
// NO bitreverse swap
// Build Merkle tree
```

### Index Calculation

Both algorithms use the same index calculation, but with different tree heights:

```
buffer_hash = Tip5_hash_varlen(merkle_root || commitment)
indexer = Tip5_hash_varlen(buffer_hash || nonce_digest)

// 63 iterations of hashing
for i in [0, 62]:
    indexer = Tip5_hash(indexer)

index_a = indexer[0] % num_leaves
index_b = indexer[1] % num_leaves

// Apply bitreverse for leaf lookup
index_a_rev = bitreverse(index_a, tree_height)
index_b_rev = bitreverse(index_b, tree_height)
```

### PoW Encoding

The PoW structure encoding is the same for both, but path lengths differ:

```
pow_encoded = [
    nonce_digest[0..4],              // 5 elements
    path_b[0..tree_height-1],        // tree_height × 5 elements
    path_a[0..tree_height-1],        // tree_height × 5 elements
    merkle_root[0..4]                // 5 elements
]

// Total: 10 + tree_height × 10 BFieldElements
// NPT: 10 + 29×10 = 300 elements
// XNT: 10 + 27×10 = 280 elements
```

---

## GUESSER BUFFER MANAGEMENT

### Buffer Rebuild Conditions

The guesser buffer is expensive to build (~2-60 seconds depending on hardware and algorithm). Proper caching is critical for performance.

#### NPT (Mainnet) - Rebuild when parent_digest changes

```python
# NPT uses parent_digest as bud prefix
if new_job.parent_digest != cached_parent_digest:
    # MUST rebuild - different block parent
    rebuild_guesser_buffer(new_job.parent_digest)
    cached_parent_digest = new_job.parent_digest
else:
    # Reuse buffer - same parent, only paths/commitment changed
    # Just update job parameters, continue mining
```

#### XNT (Testnet) - Rebuild when commitment changes

```python
# XNT uses commitment as bud prefix
new_commitment = calculate_commitment(new_job.paths)

if new_commitment != cached_commitment:
    # MUST rebuild - different commitment
    rebuild_guesser_buffer(new_commitment)
    cached_commitment = new_commitment
else:
    # Reuse buffer - same commitment
    # (This rarely happens for XNT since paths usually change)
```

### Buffer Caching Strategy

```
┌─────────────────────────────────────────────────────────────┐
│                    Job Received                              │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │   Which algorithm?     │
              └────────────────────────┘
                    │           │
                    │ NPT       │ XNT
                    ▼           ▼
        ┌───────────────┐ ┌───────────────┐
        │ parent_digest │ │  commitment   │
        │   changed?    │ │   changed?    │
        └───────────────┘ └───────────────┘
           │      │          │      │
           │ Yes  │ No       │ Yes  │ No
           ▼      ▼          ▼      ▼
       ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐
       │Rebuild│ │Reuse │ │Rebuild│ │Reuse │
       │Buffer │ │Buffer│ │Buffer │ │Buffer│
       └──────┘ └──────┘ └──────┘ └──────┘
```

### Handling extranonce1 Changes

If `extranonce1` changes (e.g., after reconnection):

1. **Discard all pending shares** - They will be rejected (wrong extranonce)
2. **Continue with current buffer** - Buffer doesn't depend on extranonce
3. **Log warning** - extranonce1 change is unusual

```python
if new_extranonce1 != old_extranonce1:
    log.warning("extranonce1 changed - discarding pending shares")
    pending_shares.clear()
    # Buffer is still valid, no rebuild needed
```

---

## DATA FORMATS

### Hex String Encoding

All hex strings in the protocol use:
- Lowercase letters (a-f)
- No 0x prefix
- Even length (leading zeros preserved)

### Integer Byte Order

| Context | Byte Order |
|---------|------------|
| u64 in digest | Little-endian |
| Nonce in buffer | Little-endian |
| Hex string parsing | Big-endian (natural reading order) |

### Example Conversions

**u64 to hex string (for submission):**
```c
uint64_t nonce = 0x00000000000001fd;
char hex[17];
sprintf(hex, "%016llx", nonce);  // "00000000000001fd"
```

**Hex string to bytes (for hashing):**
```c
// "9636d38100000000" → u64 → little-endian bytes
uint64_t val = 0x9636d38100000000;
uint8_t bytes[8];
memcpy(bytes, &val, 8);  // [00, 00, 00, 00, 81, d3, 36, 96] on LE system
```

---

## IMPLEMENTATION NOTES

### Mining Loop

```
1. Connect to pool, subscribe, authorize
2. Wait for mining.set_difficulty
3. Wait for mining.notify (may receive "no_work_available" first)
4. Calculate commitment from paths
5. Build guesser buffer (expensive, cache when possible)
6. For each nonce:
   a. Build nonce_digest = Tip5(ex1 || ex2 || nonce)
   b. Calculate indices from commitment + nonce_digest
   c. Extract leaves and paths from guesser buffer
   d. Calculate PoW digest
   e. If PoW digest < threshold: submit share
   f. Increment nonce
7. On new job:
   - If "no_work_available": pause and wait
   - If buffer key changed (parent_digest/commitment): rebuild buffer
   - Else: update job params, continue mining
```

### Handling "No Work Available"

```python
while True:
    msg = receive_message()
    
    if msg.method == "mining.notify":
        if msg.params.get("status") == "no_work_available":
            # Pool has no work - wait
            print(f"⏳ {msg.params.get('message', 'Waiting for work...')}")
            pause_mining()
            continue
        else:
            # Normal job
            process_job(msg.params.job)
            resume_mining()
```

### Nonce Distribution (Multi-GPU)

With 192-bit nonce space, distribute work using extranonce2:

```
GPU 0: extranonce2 = 0x0000000000000000, nonce = 0..2^64
GPU 1: extranonce2 = 0x0000000000000001, nonce = 0..2^64
GPU 2: extranonce2 = 0x0000000000000002, nonce = 0..2^64
...
```

### Error Handling

| Error | Action |
|-------|--------|
| Connection lost | Reconnect, re-subscribe, continue mining |
| extranonce1 changed | Discard pending shares, continue with buffer |
| "no_work_available" | Pause mining, wait for next job |
| Job ID unknown (stale share) | Log warning, continue mining |
| Low difficulty | Check vardiff, adjust if needed |
| Buffer key changed | Rebuild guesser buffer |

### Memory Requirements

| Algorithm | Guesser Buffer | Additional | Total |
|-----------|----------------|------------|-------|
| NPT (29) | ~20 GB | ~2 GB | ~22 GB |
| XNT (27) | ~5 GB | ~1 GB | ~6 GB |

---

## REFERENCE VALUES

### Block #159 Solution (NPT)

```
extranonce1: "9636d38100000000"
extranonce2: "0000000000000000"
nonce:       0x0001d9fd

nonce_digest: 9bf42981d0701194742c5bdf4b312c738a4558030b1892956708bb8ee095ba866ebf5310bf2c5887

guesser root: 165655ac726ecaf16c188b85269dee3422c4af11fe4e8e873744189e2d4e8644f3c08604501c3ffe

pow_digest:   a1c47743aff0e97e95e45a12ea6f4155bbc26dc1f749783a516a6578238cd0787b924de5f5080000
```

---

## CHANGELOG

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-11-06 | Initial release (4-byte extranonces) |
| 2.0 | 2025-12-11 | Updated to 8-byte extranonces (64-bit each), added algorithm differences (NPT/XNT), added "no_work_available" handling, added guesser buffer management details |

---

**Document Status:** Production-proven  
**Reference Implementation:** suprminer-neptune v1.3.34
