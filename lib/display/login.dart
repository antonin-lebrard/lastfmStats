library lastfmStats.login;

import 'dart:html';
import 'package:lastfmStats/display/scrollHandle.dart';
import 'package:lastfmStats/cache/cache.dart';
import 'package:lastfmStats/cache/fetch.dart';

/**
 *
 */
class Login {

  DivElement login;
  InputElement loginInput;

  ScrollHandle scrollHandle;

  Cache cache;

  Login(this.login, DivElement output){
    cache = new Cache();
    scrollHandle = new ScrollHandle(cache, output);
    cache.onCacheLoaded.listen((_) => login.style.display = "none");
    cache.load();
    List<Element> elems = login.querySelectorAll("input");
    if (elems.length == 0){
      print("No Input in login div, crash");
      return;
    }
    loginInput = elems[0];
    loginInput.onKeyPress.listen((KeyboardEvent event){
      if (event.keyCode == KeyCode.ENTER || event.keyCode == KeyCode.MAC_ENTER) {
        LastFMFetching.user = loginInput.value;
        cache.load();
        loginInput.value = "";
        login.style.display = "none";
        LastFMFetching.onError.listen((LastFMError error){
          // TODO : display modal for signaling error type etc ..
          login.style.display = "";
        });
      }
    });
  }

}