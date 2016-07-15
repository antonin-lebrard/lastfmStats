library lastfmStats.lastfmUserComponent;

import 'dart:html';
import 'package:lastfmStats/display/login.dart';
import 'package:lastfmStats/component/component.dart';
import 'package:lastfmStats/display/errorComponent.dart';
import 'package:lastfmStats/component/componentLinking.dart';

class LastfmUserComponent extends Component {

  static int _cur_z_index = 100;

  static String htmlContent =
  '''<div class="login-outer"><div class="login-middle"><div class="login-inner">
        <input class="login-username" title="username" placeholder="last.fm's username">
  </div></div></div>
  <div class="output"></div>
  <div class="error"></div>''';

  bool _hasAddedOtherComp = false;

  LastfmUserComponent(Element elem)
    : super(elem, htmlContent)
  {
    int zIndex = _cur_z_index--;
    elem.style.zIndex = "$zIndex";
  }

  @override
  void onInit(){
    DivElement output = initialElement.querySelectorAll(".output")[0];
    DivElement loginDiv = initialElement.querySelectorAll(".login-outer")[0];
    ErrorComponent errorComp = ComponentLinking.memoryLinking[initialElement.querySelectorAll(".error")[0]];
    Login login = new Login(loginDiv, errorComp, output);
    login.cache.onCacheLoaded.listen(addOtherLastfmComponent);
    login.cache.onFetchComplete.listen(addOtherLastfmComponent);
  }

  addOtherLastfmComponent(_){
    if (_hasAddedOtherComp) return;
    _hasAddedOtherComp = true;
    initialElement.insertAdjacentHtml("afterEnd", '<div class="lastfmUser"></div>');
    ensureRefresh();
  }


}