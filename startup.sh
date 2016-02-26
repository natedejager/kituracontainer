# Exit immediately if any commands fail.
set -e

echo ">> About to clone our Kitura Swift App from https://github.com/natedejager/swiftstarter..."
# Clone Swift Starter App repo
cd /root && rm -rf swiftstarter && git clone -b master https://github.com/natedejager/swiftstarter

# Build Swift Starter App
echo ">> About to build Swift Kitura App..."
cd /root/swiftstarter && swift build
echo ">> Build for Swift Kitura App finished."

# Run sample server
cd /root/swiftstarter && .build/debug/swiftstarter