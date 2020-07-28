import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarkService extends ChangeNotifier {
  List<String> bookMarks = [];
  SharedPreferences spi;
  BookMarkService() {
    getInstance();
  }
  updateBookmarks(String id, bool marked) {
    if (marked) {
      bookMarks.add(id);
    } else {
      bookMarks.remove(id);
    }
    print("BookMarks Saved" + bookMarks.toString());
    saveBookmark();
    notifyListeners();
  }

  saveBookmark() {
    spi.setStringList('bookmarks', bookMarks);
  }

  getInstance() async {
    spi = await SharedPreferences.getInstance();
    getBookmarks();
  }

  getBookmarks() {
    bookMarks = spi.getStringList('bookmarks');
    if (bookMarks == null) bookMarks = [];
    notifyListeners();
  }
}
