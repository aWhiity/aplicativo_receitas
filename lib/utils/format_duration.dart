String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  if (hours > 0) {
    return '${hours}h ${minutes}min';
  } else if (minutes > 0) {
    return '${minutes}min';
  } else {
    return 'Indefinido';
  }
}
