class Track {
  String name;
  int id;
  String album;
  String artist;
  int explicit;
  int rating;
  String lyrics;

  Track(
      {this.name,
      this.id,
      this.album,
      this.artist,
      this.explicit,
      this.rating,
      this.lyrics});
  set setname(val) => name = val;
  set setid(val) => id = val;
  set setalbum(val) => album = val;
  set setartist(val) => artist = val;
  set setexplicit(val) => explicit = val;
  set setrating(val) => rating = val;
  set setlyrics(val) => lyrics = val;

  String get trackLyrics => lyrics;
}
