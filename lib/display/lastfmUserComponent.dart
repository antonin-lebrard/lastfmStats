library lastfmStats.lastfmUserComponent;

import 'dart:html';
import 'package:lastfmStats/display/login.dart';

class LastfmUserComponent {

  LastfmUserComponent(Element elem){
    DivElement output = elem.querySelector("#output");
    DivElement login = elem.querySelector("#login-outer");
    new Login(login, output);
  }

}