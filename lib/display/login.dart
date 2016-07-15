library lastfmStats.login;

import 'dart:html';
import 'package:lastfmStats/display/scrollHandle.dart';
import 'package:lastfmStats/cache/cache.dart';
import 'package:lastfmStats/cache/fetch.dart';
import 'package:lastfmStats/display/loading.dart';
import 'package:lastfmStats/display/errorComponent.dart';

/**
 *
 */
class Login {

  DivElement loginDiv;
  InputElement loginInput;

  ScrollHandle scrollHandle;

  ErrorComponent errorComp;

  Cache cache = new Cache();

  Login(this.loginDiv, this.errorComp, DivElement output){
    scrollHandle = new ScrollHandle(cache, output);
    loginInput = loginDiv.querySelectorAll("input")[0];
    loginInput.focus();
    loginInput.onKeyPress.listen((KeyboardEvent event){
      if (event.keyCode == KeyCode.ENTER || event.keyCode == KeyCode.MAC_ENTER) {
        new Loading(cache, output);
        cache.load(loginInput.value);
        cache.fetchComp.onError.listen((LastFMError error){
          print(error);
          errorComp.displayError(error.message);
        });
      }
    });
  }

}