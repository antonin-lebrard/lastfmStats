library lastfmStats.componentLinking;

import 'dart:html';
import 'package:lastfmStats/component/component.dart';

/**
 * In some way, this Class try to do the component linking mechanism of Angular,
 * but my scope is very limited, and I would profit effectively from less than 10 percent of it
 * So here is a very cumbersome and very specific code to handle only my cases
 *
 * Link Html class to a Dart class that will be instantiated for each Html Element with such class
 */
class ComponentLinking {

  static Map<Element, Component> memoryLinking = new Map();

  static Map<String, Function> htmlClassToComponent = new Map();

  static registerComponent(String htmlClass, Component allocateComponent(Element elem)){
    htmlClassToComponent[htmlClass] = allocateComponent;
  }

  static refresh(){
    htmlClassToComponent.forEach((String htmlClass, Component allocateComponent(Element elem)){
      querySelectorAll(".${htmlClass}").forEach((Element foundElem){
        if (!memoryLinking.containsKey(foundElem)) {
          Component linked = allocateComponent(foundElem);
          memoryLinking[foundElem] = linked;
        }
      });
    });
  }

}