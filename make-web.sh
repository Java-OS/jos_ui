#!/bin/bash 

# rm -rf build/ 
flutter build web --dart-define=FLUTTER_WEB_CANVASKIT_URL=/canvaskit/
