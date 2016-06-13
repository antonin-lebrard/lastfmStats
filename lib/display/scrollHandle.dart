library lastfmStats.scroll;

import 'package:lastfmStats/cache/cache.dart';
import 'dart:html';
import 'package:lastfmStats/display/artist.dart';


class ScrollHandle {

  Cache cache;
  DivElement output;
  bool cacheLoaded = false;

  int h;
  int nextIndex = 0;

  ScrollHandle(this.cache, this.output){
    cache.onFetchComplete.listen((_)=>_display(true));
    cache.onCacheLoaded.listen(_display);
    cache.load();
    _init();
  }

  _init(){
    h = window.innerHeight;
    window.onScroll.listen((_){
      _checkOutputFilling();
    });
  }

  _display([bool fromFetch = false]){
    if (fromFetch){ return; }
    _fillOutput();
  }

  _checkOutputFilling(){
    int pix = output.getBoundingClientRect().height - window.scrollY - window.innerHeight;
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