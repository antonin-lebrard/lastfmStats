library lastfmStats.scroll;

import 'package:lastfmStats/cache/cache.dart';
import 'dart:html';
import 'package:lastfmStats/display/artist.dart';


class ScrollHandle {

  Cache cache;
  DivElement output;
  bool cached = false;

  int nextIndex = 0;

  ScrollHandle(this.cache, this.output){
    cached = cache.isCachedDataPresent;
    cache.onFetchComplete.listen((_)=>_display(true));
    cache.onCacheLoaded.listen((_)=>_display());
    cache.load();
    _init();
  }

  _init(){
    window.onScroll.listen((_){
      _checkOutputFilling();
    });
  }

  _display([bool fromFetch = false]){
    if (fromFetch){
      if (!cached) _fillOutput();
      else {

      }
    }
    _fillOutput();
  }

  _checkOutputFilling(){
    num pix = output.getBoundingClientRect().height - window.scrollY - window.innerHeight;
    if (pix < 300) _fillOutput();
  }

  _fillOutput(){
    int indexToGo = nextIndex + 10;
    while (nextIndex != indexToGo) {
      if (nextIndex == cache.artists.length){
        break;
      }
      Artist a = cache.artists[nextIndex];
      nextIndex++;
      output.append(a.createDiv());
    }
    _checkOutputFilling();
  }

}