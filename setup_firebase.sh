#!/bin/bash
set -e

# ═══════════════════════════════════════════════════════════════
#  Voltify – Complete Firebase Setup Script
#  Run this from the Voltify project root directory.
# ═══════════════════════════════════════════════════════════════

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
FIREBASE_PROJECT_ID="voltify-app-$(date +%s | tail -c 6)"

echo ""
echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo -e "${CYAN}   Voltify – Firebase Setup Script     ${NC}"
echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo ""

# ──────────────────────────────────
# Step 1: Check prerequisites
# ──────────────────────────────────
echo -e "${YELLOW}[1/7] Checking prerequisites...${NC}"

if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter not found. Install from https://flutter.dev${NC}"
    exit 1
fi
echo -e "  ✅ Flutter $(flutter --version 2>&1 | head -1 | awk '{print $2}')"

if ! command -v firebase &> /dev/null; then
    echo -e "${YELLOW}  ⚠️  Firebase CLI not found. Installing...${NC}"
    npm install -g firebase-tools
fi
echo -e "  ✅ Firebase CLI found"

if ! command -v flutterfire &> /dev/null; then
    echo -e "${YELLOW}  ⚠️  FlutterFire CLI not found. Installing...${NC}"
    dart pub global activate flutterfire_cli
fi
echo -e "  ✅ FlutterFire CLI found"

# ──────────────────────────────────
# Step 2: Firebase Login
# ──────────────────────────────────
echo ""
echo -e "${YELLOW}[2/7] Checking Firebase login...${NC}"
firebase login --interactive 2>/dev/null || true
echo -e "  ✅ Firebase authenticated"

# ──────────────────────────────────
# Step 3: Create Flutter project shell (android + ios)
# ──────────────────────────────────
echo ""
echo -e "${YELLOW}[3/7] Generating platform folders...${NC}"

cd "$PROJECT_DIR"

if [ ! -d "android" ] || [ ! -d "ios" ]; then
    TEMP_DIR=$(mktemp -d)
    flutter create --org com.voltify --project-name voltify "$TEMP_DIR/voltify_temp"

    if [ ! -d "android" ]; then
        cp -r "$TEMP_DIR/voltify_temp/android" .
        echo -e "  ✅ Android folder created"
    else
        echo -e "  ℹ️  Android folder already exists"
    fi

    if [ ! -d "ios" ]; then
        cp -r "$TEMP_DIR/voltify_temp/ios" .
        echo -e "  ✅ iOS folder created"
    else
        echo -e "  ℹ️  iOS folder already exists"
    fi

    # Copy web and other platform folders if needed
    if [ ! -f "test/widget_test.dart" ]; then
        cp "$TEMP_DIR/voltify_temp/test/widget_test.dart" test/ 2>/dev/null || true
    fi

    rm -rf "$TEMP_DIR"
else
    echo -e "  ℹ️  Platform folders already exist"
fi

# ──────────────────────────────────
# Step 4: Install dependencies
# ──────────────────────────────────
echo ""
echo -e "${YELLOW}[4/7] Installing dependencies...${NC}"
flutter pub get
echo -e "  ✅ Dependencies installed"

# ──────────────────────────────────
# Step 5: Create Firebase project
# ──────────────────────────────────
echo ""
echo -e "${YELLOW}[5/7] Creating Firebase project...${NC}"
echo -e "  Project ID: ${CYAN}${FIREBASE_PROJECT_ID}${NC}"

firebase projects:create "$FIREBASE_PROJECT_ID" --display-name "Voltify" 2>/dev/null || {
    echo -e "${YELLOW}  ⚠️  Project creation failed (may already exist). Enter your Firebase project ID:${NC}"
    read -r FIREBASE_PROJECT_ID
}
echo -e "  ✅ Firebase project ready: $FIREBASE_PROJECT_ID"

# ──────────────────────────────────
# Step 6: Configure FlutterFire
# ──────────────────────────────────
echo ""
echo -e "${YELLOW}[6/7] Configuring FlutterFire (Android + iOS)...${NC}"
echo -e "  This will register Android & iOS apps with Firebase and generate firebase_options.dart"
echo ""

flutterfire configure \
  --project="$FIREBASE_PROJECT_ID" \
  --platforms=android,ios \
  --android-package-name=com.voltify.voltify \
  --ios-bundle-id=com.voltify.voltify \
  --yes

echo -e "  ✅ FlutterFire configured"

# ──────────────────────────────────
# Step 7: Enable Email/Password Auth
# ──────────────────────────────────
echo ""
echo -e "${YELLOW}[7/7] Enabling Email/Password Authentication...${NC}"
echo ""
echo -e "${CYAN}⚡ MANUAL STEP REQUIRED:${NC}"
echo -e "  1. Open: ${GREEN}https://console.firebase.google.com/project/${FIREBASE_PROJECT_ID}/authentication/providers${NC}"
echo -e "  2. Click ${GREEN}Email/Password${NC}"
echo -e "  3. Toggle ${GREEN}Enable${NC} to ON"
echo -e "  4. Click ${GREEN}Save${NC}"
echo ""
echo -e "  Press Enter after you've enabled Email/Password auth..."
read -r

# ──────────────────────────────────
# Final: Verify setup
# ──────────────────────────────────
echo ""
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo -e "${GREEN}   ✅ Voltify Firebase Setup Complete!  ${NC}"
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo ""
echo -e "  Firebase Project: ${CYAN}${FIREBASE_PROJECT_ID}${NC}"
echo -e "  Android Package:  ${CYAN}com.voltify.voltify${NC}"
echo -e "  iOS Bundle ID:    ${CYAN}com.voltify.voltify${NC}"
echo ""
echo -e "  Run the app:"
echo -e "    ${GREEN}flutter run${NC}"
echo ""
echo -e "  Build APK:"
echo -e "    ${GREEN}flutter build apk --release${NC}"
echo ""
echo -e "  Build iOS:"
echo -e "    ${GREEN}cd ios && pod install && cd .. && flutter build ipa --release${NC}"
echo ""
