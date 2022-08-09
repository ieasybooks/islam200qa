const List<String> englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

const List<String> arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

const List<String> arabicDiacritics = ['َ', 'ُ', 'ِ', 'ً', 'ٌ', 'ٍ', 'ْ', 'ّ'];

const Map<String, String> arabicCharactersNormalizationMapping = {
  "أ": "ا",
  "إ": "ا",
  "آ": "ا",
  "ء": "ا",
  "ؤ": "و",
  "ئ": "ى",
  "ي": "ى",
  "ة": "ه",
};

String arabizeNumbers(final String input) {
  String output = input;

  for (int i = 0; i < englishNumbers.length; ++i) {
    output = output.replaceAll(englishNumbers[i], arabicNumbers[i]);
  }

  return output;
}

String removeArabicDiacritics(final String input) {
  String output = input;

  for (int i = 0; i <arabicDiacritics.length; ++i) {
    output = output.replaceAll(arabicDiacritics[i], '');
  }

  return output;
}

String normalizeArabicText(final String input) {
  String output = removeArabicDiacritics(input);

  arabicCharactersNormalizationMapping.forEach((key, value) {
    output = output.replaceAll(key, value);
  });

  return output;
}
