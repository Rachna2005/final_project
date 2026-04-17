String formatBikeId(String id) {
  final number = id.split('_').last; // "001"
  final intValue = int.parse(number);
  return "#${intValue.toString().padLeft(3, '0')}";
}
