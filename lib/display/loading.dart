library lastFmStats.loading;


import 'dart:html';
import 'package:lastfmStats/cache/fetch.dart';
import 'package:lastfmStats/cache/cache.dart';
import 'package:lastfmStats/helper/window.dart';

class Loading {

  DivElement loading = new DivElement();

  Cache cache;

  Element toHide;

  Loading(this.cache, this.toHide){
    loading.style.display = 'none';
    WindowHelper.lineHeightEqualsInnerHeight(loading);
    loading.classes.add("loading");
    loading.classes.add(cache.usernamePresent ? "loadingWithCache" : "loadingWithoutCache");
    loading.style.width = toHide.parent.style.width;
    toHide.parent.append(loading);
    cache.remoteFetch.loading.listen((percentage){
      loading.style.display = '';
      loading.text = percentage.toString() + "%";
      if (percentage == 100)
        loading.style.display = 'none';
    });
  }

}