const List<String> englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
const List<String> arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

String arabizeNumbers(String input) {
  for (int i = 0; i < englishNumbers.length; i++) {
    input = input.replaceAll(englishNumbers[i], arabicNumbers[i]);
  }

  return input;
}
