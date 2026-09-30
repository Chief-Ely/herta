import 'package:flutter/material.dart';

class PlaylistData extends ChangeNotifier {
  final List<String> _tracks = [
    'Title: Lorem Ipsum 1',
    'Title: Lorem Ipsum 2',
    'Title: Lorem Ipsum 3',
    'Title: Lorem Ipsum 4',
  ];

  List<String> get tracks => _tracks;

  void addTrack(String title) {
    _tracks.add(title);
    notifyListeners();
  }
}