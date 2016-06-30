library lastfmStats.componentLinking;

import 'dart:html';

/**
 * In some way, this Class try to do the component linking mechanism of Angular,
 * but my scope is very limited, and I would profit effectively from less than 10 percent of it
 * So here is a very cumbersome and very specific code to handle only my cases
 *
 * Link Html class to a Dart class that will be instantiated for each Html Element with such class
 */
class ComponentLinking {

  static Map<String, Function> htmlClassToComponent = new Map();

  static registerComponent(String htmlClass, Function allocateComponent(Element elem)){
    htmlClassToComponent[htmlClass] = allocateComponent;
  }

  static launchInstantiating(){
    htmlClassToComponent.forEach((String htmlClass, Function allocateComponent(Element elem)){
      querySelectorAll(".${htmlClass}").forEach((Element foundElem){
        allocateComponent(foundElem);
      });
    });
  }

}