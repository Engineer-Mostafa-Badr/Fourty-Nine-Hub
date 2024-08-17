# for build_runner
# flutter pub run build_runner build --delete-conflicting-outputs

# for localization 
flutter pub run easy_localization:generate -S assets/translations -O lib/core/localization
flutter pub run easy_localization:generate -S assets/translations -O lib/core/localization -f keys -o locale_keys.g.dart


