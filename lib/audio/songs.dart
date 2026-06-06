// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

const Set<Song> songs = {
  // 16-Bit Fantasy Action Music Pack by Joel Steudler (Humble Bundle)
  // Note: filenames with whitespace break package:audioplayers on iOS,
  // but underscored filenames work fine.
  Song('Menu_-_Noble_Kingdom.ogg', 'Noble Kingdom', artist: 'Joel Steudler'),
  Song('Action_-_Knightly_Fighting.ogg', 'Knightly Fighting', artist: 'Joel Steudler'),
  Song('Action_-_Surge_Forward.ogg', 'Surge Forward', artist: 'Joel Steudler'),
  Song('Action_-_Challenge_Fate.ogg', 'Challenge Fate', artist: 'Joel Steudler'),
};

class Song {
  final String filename;

  final String name;

  final String? artist;

  const Song(this.filename, this.name, {this.artist});

  @override
  String toString() => 'Song<$filename>';
}
