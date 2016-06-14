library lastFmStats.loading;


import 'dart:html';
import 'package:lastfmStats/cache/fetch.dart';
import 'package:lastfmStats/cache/cache.dart';
import 'package:lastfmStats/helper/window.dart';

class Loading {

  DivElement loading = new DivElement();

  Cache cache;

  Loading(this.cache){
    loading.style.display = 'none';
    WindowHelper.lineHeightEqualsInnerHeight(loading);
    loading.id = "loading";
    loading.classes.add(cache.isCachedDataPresent ? "loadingWithCache" : "loadingWithoutCache");
    querySelector('body').append(loading);
    LastFMFetching.loading.listen((percentage){
      loading.style.display = '';
      loading.text = percentage.toString() + "%";
      if (percentage == 100)
        loading.style.display = 'none';
    });
  }

}