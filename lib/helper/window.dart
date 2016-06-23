library lastfmStats.window;

import 'dart:html';

class WindowHelper {

  static lineHeightEqualsInnerHeight(DivElement div){
    div.style.lineHeight = "${window.innerHeight}px";
    window.onResize.listen((_)=>div.style.lineHeight = "${window.innerHeight}px");
  }

  static int getHeightValueFromCSS(Element elem){
    List<Element> sameElems = querySelectorAll(elem.classes.join(" "));
    if (sameElems.length == 0) return 0;
    String h = sameElems[0].getComputedStyle().height;
    return int.parse(h.substring(0, h.indexOf("px")));
  }

}