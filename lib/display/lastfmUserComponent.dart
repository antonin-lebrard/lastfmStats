library lastfmStats.lastfmUserComponent;

import 'dart:html';
import 'package:lastfmStats/display/login.dart';
import 'package:lastfmStats/component/component.dart';

class LastfmUserComponent extends Component {

  static String htmlContent =
  '''<div id="login-outer"><div id="login-middle"><div id="login-inner">
        <input id="login-username" title="username" placeholder="last.fm's username">
  </div></div></div>
  <div id="output"></div>''';

  bool _hasAddedOtherComp = false;

  LastfmUserComponent(Element elem)
    : super(elem, htmlContent)
  {
    DivElement output = elem.querySelector("#output");
    DivElement loginDiv = elem.querySelector("#login-outer");
    Login login = new Login(loginDiv, output);
    login.cache.onCacheLoaded.listen(addOtherLastfmComponent);
    login.cache.onFetchComplete.listen(addOtherLastfmComponent);
  }

  addOtherLastfmComponent(_){
    if (_hasAddedOtherComp) return;
    _hasAddedOtherComp = true;
    initialElement.insertAdjacentHtml("afterEnd", '<div class="lastfmUser"></div>');
  }


}