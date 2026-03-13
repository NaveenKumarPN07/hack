#!/bin/bash

echo ""
echo "========================================"
echo "   DisasterNet - Auto Setup for Mac"
echo "========================================"
echo ""

# Step 1: Check Node.js
echo "Step 1: Checking Node.js..."
if ! command -v node &> /dev/null; then
  echo "  Node.js not found. Installing via Homebrew..."
  brew install node
else
  echo "  Node.js found: $(node -v)"
fi

# Step 2: Check MongoDB
echo ""
echo "Step 2: Checking MongoDB..."
if ! command -v mongod &> /dev/null; then
  echo "  MongoDB not found. Installing..."
  brew tap mongodb/brew
  brew install mongodb-community
else
  echo "  MongoDB found."
fi

# Step 3: Start MongoDB
echo ""
echo "Step 3: Starting MongoDB..."
brew services start mongodb-community
echo "  MongoDB started."

# Step 4: Install root dependencies
echo ""
echo "Step 4: Installing root dependencies..."
npm install
echo "  Done."

# Step 5: Install server dependencies
echo ""
echo "Step 5: Installing server dependencies..."
cd server && npm install && cd ..
echo "  Done."

# Step 6: Install client dependencies
echo ""
echo "Step 6: Installing client dependencies (this takes 2-3 mins)..."
cd client && npm install && cd ..
echo "  Done."

echo ""
echo "========================================"
echo "  Setup complete! Starting DisasterNet..."
echo "========================================"
echo ""
echo "  Server → http://localhost:3001"
echo "  App    → http://localhost:3000"
echo ""

# Step 7: Run the app
npm run dev
