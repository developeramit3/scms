import 'dart:ffi';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
  String toTitleCase() => replaceAll(RegExp('_'), ' ').split(' ').map((str) => str.capitalize()).join(' ');
  String toUsd() => '\$'+double.parse(this).toStringAsFixed(2);
  String toPercentage(volumeApplied){
    double value = double.parse(this) * 100;
    value = value / double.parse(volumeApplied);
    return value.toStringAsFixed(2)+"%";
  }
}