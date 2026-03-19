
String formatExchangeRateForDisplay(double rate) {
  if (rate == 0) return '0';
  const normalDecimals = 4;
  const fallbackDecimals = 12;

  final decimals =
      rate.abs() < 0.0001 ? fallbackDecimals : normalDecimals;
  final s = rate.toStringAsFixed(decimals);
  return s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
}
