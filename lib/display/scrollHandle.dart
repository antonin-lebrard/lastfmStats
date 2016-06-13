library lastfmStats.scroll;

import 'package:lastfmStats/cache/cache.dart';
import 'dart:html';
import 'package:lastfmStats/display/artist.dart';


class ScrollHandle {

  Cache cache;
  DivElement output;

  ScrollHandle(this.cache, this.output){
    cache.onFetchComplete.listen(_display);
    cache.onCacheLoaded.listen(_display);
    cache.load();
  }

  _display(_){
    output.children.clear();
    for (Artist a in cache.artists){
      output.append(a.createDiv());
    }
  }

}