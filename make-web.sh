#!/bin/bash 

rm -rf build/ 
flutter clean ; flutter build web --web-renderer=canvaskit --dart-define=FLUTTER_WEB_CANVASKIT_URL=/canvaskit/
