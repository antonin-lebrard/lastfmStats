library lastfmStats.scroll;

import 'dart:html';
import 'package:lastfmStats/cache/cache.dart';
import 'package:lastfmStats/display/artist.dart';
import 'package:lastfmStats/display/errorComponent.dart';


class ScrollHandle {

  Cache cache;
  DivElement output;
  ErrorComponent errorComp;

  int nextIndex = 0;

  ScrollHandle(this.cache, this.output, this.errorComp){
    cache.onFetchComplete.listen((_)=>_display(true));
    cache.onCacheLoaded.listen((_)=>_display());
    _init();
  }

  _init(){
    window.onScroll.listen((_){
      _checkOutputFilling();
    });
  }

  _display([bool fromFetch = false]){
    if (fromFetch){
      if (!cache.usernamePresent) _fillOutput();
      else {
        errorComp.displayUpdate("Update Now").then((isUpdating){
          if (!isUpdating) return;
          output.innerHtml = "";
          nextIndex = 0;
          _fillOutput();
        });
      }
    }
    _fillOutput();
  }

  _checkOutputFilling(){
    num pix = output.getBoundingClientRect().height - window.scrollY - window.innerHeight;
    if (pix < 300) _fillOutput();
  }

  _fillOutput(){
    if (cache.artists.length == 0) return;
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