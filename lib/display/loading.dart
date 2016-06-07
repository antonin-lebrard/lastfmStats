library lastFmStats.loading;


import 'dart:html';
import 'package:lastfmStats/cache/fetch.dart';

class Loading {

  DivElement loading = new DivElement();

  Loading(){
    loading.style.display = 'none';
    loading.id = "loading";
    querySelector('body').append(loading);
    LastFMFetching.loading.listen((percentage){
      loading.style.display = '';
      loading.text = percentage.toString() + "%";
      if (percentage == 100)
        loading.style.display = 'none';
    });
  }

}