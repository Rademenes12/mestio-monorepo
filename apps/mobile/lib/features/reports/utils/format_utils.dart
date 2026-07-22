/// Safe id shortener for UI labels — guards against ids shorter than [length]
/// (legacy/seed reports can have very short ids). Always returns uppercase.
String shortId(String id, int length) {
  final end = id.length < length ? id.length : length;
  return id.substring(0, end).toUpperCase();
}

String formatTimestamp(int timestampMs) {
  final dt = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  final day = dt.day.toString().padLeft(2, '0');
  final month = dt.month.toString().padLeft(2, '0');
  final hour = dt.hour.toString().padLeft(2, '0');
  final minute = dt.minute.toString().padLeft(2, '0');
  return '$day.$month.${dt.year} $hour:$minute';
}
