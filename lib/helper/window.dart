library lastfmStats.window;

import 'dart:html';

class WindowHelper {

  static lineHeightEqualsInnerHeight(DivElement div, [Element beEqualsTo]){
    int calculateHeight(Element elem){
      int scrollTop = elem.scrollTop;
      int scrollBot = scrollTop + elem.clientHeight;
      int elTop = elem.offset.top;
      int elBottom = elTop + elem.clientHeight;
      int visibleTop = elTop < scrollTop ? scrollTop : elTop;
      int visibleBottom = elBottom > scrollBot ? scrollBot : elBottom;
      return visibleBottom - visibleTop;
    }
    if (beEqualsTo == null) {
      div.style.lineHeight = "${window.innerHeight}px";
      window.onResize.listen((_)=>div.style.lineHeight = "${window.innerHeight}px");
    } else {
      div.style.lineHeight = "${calculateHeight(beEqualsTo)}px";
      window.onResize.listen((_) => div.style.lineHeight = "${calculateHeight(beEqualsTo)}px");
    }
  }

  static int getHeightValueFromCSS(Element elem){
    List<Element> sameElems = querySelectorAll(elem.classes.join(" "));
    if (sameElems.length == 0) return 0;
    String h = sameElems[0].getComputedStyle().height;
    return int.parse(h.substring(0, h.indexOf("px")));
  }

}