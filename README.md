# 🌐 DisasterNet

**Offline mesh communication network for disaster scenarios.**  
No internet. No cell towers. No server required. Every smartphone becomes a mesh node.

---

## 🚀 Quick Start (VS Code)

### Prerequisites
- Node.js v18+ 
- MongoDB (local) — `mongod --dbpath ./data`
- npm

### 1. Install dependencies
```bash
# From project root
npm install          # installs concurrently
cd server && npm install
cd ../client && npm install
cd ..
```

### 2. Configure the server
Edit `server/.env`:
```env
PORT=3001
MONGO_URI=mongodb://localhost:27017/disasternet
PEERS=                    # leave empty for single-node
MESSAGE_TTL=10
```

### 3. Run in development
```bash
npm run dev
# → Server: http://localhost:3001
# → Client: http://localhost:3000
```

### 4. Open the app
- Browser: http://localhost:3000
- From another device on the same network: http://<your-ip>:3001

---

## 🕸️ Multi-Node Mesh Setup

To run a real mesh across multiple devices on the same Wi-Fi hotspot:

**Node A** (IP: 192.168.1.100):
```env
PEERS=http://192.168.1.101:3001
```

**Node B** (IP: 192.168.1.101):
```env
PEERS=http://192.168.1.100:3001
```

Messages sent on one node will gossip to all peers every 30 seconds, and instantly on broadcast.

---

## 📡 How It Works

```
User broadcasts alert
    ↓
POST /api/messages → Express → SHA-256 hash → MongoDB (dedup)
    ↓
Socket.IO → pushes to ALL browsers on this node instantly
    ↓
Gossip engine → POSTs to peer nodes (TTL-1, hopCount+1)
    ↓
Stops at TTL=0 (default: 10 hops)
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React 18, PWA, Socket.IO client |
| Backend | Node.js, Express, Socket.IO |
| Database | MongoDB (local, TTL index, SHA-256 dedup) |
| Transport | Local Wi-Fi, HTTP gossip, LoRa (optional) |
| AI | Transformers.js (offline, WebAssembly) |
| Maps | Leaflet + OpenStreetMap (cached tiles) |

---

## 📁 Project Structure

```
disasternet/
├── server/
│   ├── index.js              # Main entry point
│   ├── .env                  # Configuration
│   ├── models/
│   │   └── Message.js        # MongoDB schema
│   ├── routes/
│   │   ├── messages.js       # REST API + sync endpoint
│   │   └── peers.js          # Peer management
│   └── utils/
│       ├── gossip.js         # Mesh gossip engine
│       └── lora.js           # LoRa radio bridge
├── client/
│   ├── public/
│   │   ├── index.html
│   │   ├── manifest.json     # PWA manifest
│   │   └── service-worker.js # Offline caching
│   └── src/
│       ├── App.js            # 4-tab layout
│       ├── components/
│       │   ├── AlertFeed.js        # Real-time message feed
│       │   ├── BroadcastComposer.js # Send alerts + AI triage
│       │   ├── OfflineMap.js       # Leaflet alert map
│       │   └── NodeStatus.js       # Mesh health dashboard
│       └── utils/
│           ├── socket.js     # Socket.IO + API helpers
│           └── ai.js         # Offline AI (Transformers.js)
└── package.json              # Root workspace
```

---

## 📻 LoRa Extension (Optional)

Extends mesh range to 5–15 km via radio hardware (~₹15 SX1276 module):

```env
LORA_PORT=/dev/ttyUSB0
LORA_BAUD=9600
```

Pre-place LoRa nodes at hospitals, schools, fire stations for city-wide coverage.

---

## 🧠 Offline AI Features

All AI runs in the browser via WebAssembly — no API key, no internet:

- **Triage** — auto-classifies message priority (Critical/High/Medium/Low)
- **Semantic dedup** — blocks near-duplicate alerts before sending (~60% noise reduction)
- **Language detection** — detects 9 Indian scripts automatically

---

## 🔐 Security

- SHA-256 hash deduplication on all messages
- Ed25519 signature support for verified official alerts
- TTL-based propagation prevents infinite loops

---

## 📦 Build for Production

```bash
npm run build
# Serves React build from Express at http://localhost:3001
NODE_ENV=production npm start
```
