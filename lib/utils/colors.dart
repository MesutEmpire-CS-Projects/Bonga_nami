import 'package:flutter/material.dart';

Color _getColorFromName(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'yellow':
      return Colors.yellow;
    case 'black':
      return Colors.black;
    case 'white':
      return Colors.white;
    case 'orange':
      return Colors.orange;
    case 'purple':
      return Colors.purple;
    case 'pink':
      return Colors.pink;
    case 'cyan':
      return Colors.cyan;
    case 'magenta':
      return Colors.pinkAccent; // Closest to magenta
    case 'brown':
      return Colors.brown;
    case 'grey':
    case 'gray': // Both spellings
      return Colors.grey;
    case 'lime':
      return Colors.lime;
    case 'indigo':
      return Colors.indigo;
    case 'teal':
      return Colors.teal;
    case 'amber':
      return Colors.amber;
    case 'gold':
      return Colors.amberAccent;
    case 'violet':
      return Colors.purpleAccent;
    case 'navy':
      return Colors.blueGrey;
    case 'khaki':
      return Colors.yellow[700]!;
    default:
      return Colors.white;
  }
}

Map<String, dynamic> splitInputAndColor(String input) {
  List<String> results =
      input.split(' ').where((data) => colors.contains(data)).toList();
  String color = results.isNotEmpty ? results.first : 'white';
  return {"color": _getColorFromName(color), "name": color};
}

List<String> colors = [
  'red',
  'blue',
  'green',
  'yellow',
  'black',
  'white',
  'orange',
  'purple',
  'pink',
  'cyan',
  'magenta',
  'brown',
  'grey',
  'gray',
  'lime',
  'indigo',
  'teal',
  'amber',
  'gold',
  'violet',
  'navy',
  'khaki'
];
