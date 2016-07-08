library lastfmStats.conductor;
import 'dart:html';
import 'package:lastfmStats/display/lastfmUserComponent.dart';
import 'package:lastfmStats/component/componentLinking.dart';


class Conductor {

  static Map<String, Function> _toRegister = {
    "lastfmUser": (Element elem) => new LastfmUserComponent(elem),
  };

  static Conductor _singleton;

  factory Conductor() {
    if (_singleton == null)
      _singleton = new Conductor._internal();
    return _singleton;
  }

  Conductor._internal(){
    _toRegister.forEach((String key, Function value){
      ComponentLinking.registerComponent(key, value);
    });
    window.onLoad.listen((_){
      ComponentLinking.refresh();
    });
    window.onChange.listen((_){
      ComponentLinking.refresh();
    });
  }

}