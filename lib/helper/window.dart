library lastfmStats.window;

import 'dart:html';

class WindowHelper {

  static lineHeightEqualsInnerHeight(DivElement div){
    div.style.lineHeight = "${window.innerHeight}px";
    window.onResize.listen((_)=>div.style.lineHeight = "${window.innerHeight}px");
  }

}