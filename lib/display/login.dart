library lastfmStats.login;

import 'dart:html';
import 'package:lastfmStats/display/scrollHandle.dart';
import 'package:lastfmStats/cache/cache.dart';
import 'package:lastfmStats/cache/fetch.dart';
import 'package:lastfmStats/display/loading.dart';

/**
 *
 */
class Login {

  DivElement login;
  InputElement loginInput;

  ScrollHandle scrollHandle;

  Cache cache = new Cache();

  Login(this.login, DivElement output){
    scrollHandle = new ScrollHandle(cache, output);
    List<Element> elems = login.querySelectorAll("input");
    if (elems.length == 0){
      print("No Input in login div, crash");
      return;
    }
    loginInput = elems[0];
    loginInput.focus();
    loginInput.onKeyPress.listen((KeyboardEvent event){
      if (event.keyCode == KeyCode.ENTER || event.keyCode == KeyCode.MAC_ENTER) {
        new Loading(cache, output);
        cache.load(loginInput.value);
        cache.fetchComp.onError.listen((LastFMError error){
          print(error);
          // TODO : display modal for signaling error type etc ..
        });
      }
    });
  }

}