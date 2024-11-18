int hexToString(String hex) {
  // Ensure the hex string has an even length by prepending '0' if needed
  if (hex.length % 2 != 0) {
    hex = "0$hex";
  }

  // Parse the hex string as a base-16 integer
  int num = int.parse(hex, radix: 16);

  // Calculate the maximum value based on the byte size
  int maxVal = (1 << (hex.length ~/ 2 * 8)); // Equivalent to Math.pow(2, hex.length / 2 * 8)

  // Handle signed integer representation
  if (num > maxVal ~/ 2 - 1) {
    num -= maxVal;
  }

  return num;
}