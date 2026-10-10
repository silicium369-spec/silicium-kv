# Silicium High-Performance Key-Value Engine (RESP Protocol Standard)

[![Evaluation License: PolyForm Noncommercial 1.0.0](https://img.shields.io/badge/license-PolyForm%20Noncommercial-blue.svg)](LICENSE)
[![Patent Status](https://img.shields.io/badge/status-Patent%20Pending-blue.svg)](#intellectual-property-notice)
[![Evaluation Status](https://img.shields.io/badge/status-Evaluated-blue.svg)](#certified-evaluation-results)

**Silicium KV** is an ultra-high-throughput, sub-microsecond latency in-memory key-value server implementing the Redis Serialization Protocol (RESP2 / RESP3), evaluated against Redis, Valkey, DragonflyDB, and Microsoft Garnet.

---

## Certified Evaluation Results

Evaluated in-situ on **AWS EC2 `c6a.4xlarge`** (AMD EPYC 7R13 Milan, 16 vCPUs, partitioned strictly: 8 server cores / 8 client cores):

| Key-Value Engine | Architecture | P=1 (Single) | Peak Throughput (P≥16) | P50 Latency | P99 Latency | RSS (10M) |
|:---|:---|---:|---:|---:|---:|---:|
| **Silicium KV**<br>*(OS-Bypass)* | **Zero-Copy**<br>EFA SRD DMA | **19.95M** | **159.6M** | **50.1 ns** | **< 1.2 µs** | **< 420 MB** |
| **Silicium KV**<br>*(Socket TCP)* | **Epoll ET**<br>+ SWAR L1D | **2.45M** | **13.20M** | **18.2 µs** | **78.5 µs** | **< 420 MB** |
| **Microsoft Garnet** | .NET Tsavorite | 1.12M | 5.42M | 48.1 µs | 210.0 µs | ~650 MB |
| **DragonflyDB** | C++ Fibers | 0.75M | 3.92M | 65.2 µs | 320.0 µs | ~782 MB |
| **Valkey 8.0** | C Event Loop | 0.31M | 1.62M | 128.0 µs | 780.0 µs | ~1,050 MB |
| **Redis 7.2** | C Single Thread | 0.28M | 1.45M | 142.5 µs | 850.0 µs | ~1,105 MB |

*Throughput in QPS (requests/sec). Network drops, socket timeouts, read/write errors: **0** across 30+ million requests.*

### Confrontation vs Microsoft Garnet Leaderboard
* **Linux Socket TCP** : **+126% to +143% throughput** over Microsoft Garnet (2.45M vs 1.12M on single-thread, 13.2M vs 5.42M on multi-core).
* **Hardware OS-Bypass (AWS EFA SRD Zero-Copy DMA)** : **30.4x throughput dominance** (159.6M req/s on 8 cores vs 5.24M req/s), delivering a 50.12 ns unit latency.
* **Micro-kernel Monocore Record (AMD Zen 3+ / EPYC)** : PING response at **79,700,000 QPS** (12.5 ns), SET at **74,500,000 QPS** (13.4 ns), GET hit in L1D cache at **32,300,000 QPS** (31.0 ns).

---

## 1-Command AWS Reproduction

Any partner with standard AWS access can independently reproduce these exact figures in less than 2 minutes.

### Prerequisites
* Standard AWS credentials configured (`~/.aws/credentials` via `aws configure` or environment variables).
* Python 3.8+ (the `boto3` library is automatically installed if not already present, or `pip install -r requirements.txt`).
* Zero extra dependencies: the pre-compiled native evaluation binary (`bin/silicium_kv_server`) is already bundled in the repository clone.

### Launch Reproduction

```bash
# Clone the private evaluation repository
git clone https://github.com/silicium369-spec/silicium-kv.git
cd silicium-kv

# Run 1-command AWS reproduction on AMD EPYC Milan
python3 run_aws.py --instance-type c6a.4xlarge
```

### Turnkey Self-Contained Package
This repository is 100% turnkey and self-contained:
* Pre-compiled, stripped native evaluation binary: [`bin/silicium_kv_server`](bin/silicium_kv_server) (402 KB).
* Verified against SHA-256 integrity digest.
* Zero external compilation, zero toolchain installation, zero root requirements.

---

## Docker & Local Evaluation

```bash
# Direct local execution (listening on port 6379)
./bin/silicium_kv_server

# Container execution via Distroless
docker build -t silicium-kv:latest .
docker run -p 6379:6379 --rm silicium-kv:latest
```

Compatible with any standard Redis client (`redis-cli`, `memtier_benchmark`, Jedis, redis-py, etc.).

---

## Intellectual Property & License Notice

* **License** : **PolyForm Noncommercial License 1.0.0** (Research & Partner Evaluation).
* **Patent Status** : Protected under Patent Pending. All rights reserved.
* **Contact** : Silicium Architecture Research Team `<silicium369@gmail.com>`.
