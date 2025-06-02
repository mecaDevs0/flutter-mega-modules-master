extension StringExtension on String? {
  String get capitalize {
    if (this == null) {
      return '';
    }
    return '${this![0].toUpperCase()}${this!.substring(1)}';
  }

  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }
}
