library lastfmStats.component;

import 'dart:html';

class Component {

  Element initialElement;

  Component(this.initialElement, String htmlContent){
    _fillHtmlContent(htmlContent);
  }

  void _fillHtmlContent(String htmlContent){
    initialElement.setInnerHtml(htmlContent);;
  }

}