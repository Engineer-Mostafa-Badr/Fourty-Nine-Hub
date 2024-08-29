# for build_runner
# flutter pub run build_runner build --delete-conflicting-outputs

# for localization 
flutter pub run easy_localization:generate -S assets/translations -O lib/core/localization
flutter pub run easy_localization:generate -S assets/translations -O lib/core/localization -f keys -o locale_keys.g.dart



# for build_runner
flutter pub run build_runner build --delete-conflicting-outputs

# for localization 
flutter pub run easy_localization:generate -S assets/translations -O lib/core/localization
flutter pub run easy_localization:generate -S assets/translations -O lib/core/localization -f keys -o locale_keys.g.dart
# the following code is for replacing the ';' with '.tr()' to call LocaleKeys.varName without .tr()
# Define the input file
input_file="lib/core/localization/locale_keys.g.dart"

# Use sed to replace all occurrences of ';' with '.tr();'
sed -i 's/;/\.tr();/g' "$input_file"
# Use sed to replace all occurrences of 'const' with 'String'
sed -i 's/const/\String/g' "$input_file"

# Insert the easy_localization import at the top of the file
import_statement="import 'package:easy_localization/easy_localization.dart';"
# Check if the line already exists in the file
if ! grep -Fxq "$import_statement" "$input_file"
then
    # Add the line to the top of the file
    echo "$import_statement" | cat - "$input_file" > temp && mv temp "$input_file"
    echo "Line added successfully."
else
    echo "Line already exists in the file."
fi