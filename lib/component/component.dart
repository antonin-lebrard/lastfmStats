library lastfmStats.component;

import 'dart:html';
import 'package:lastfmStats/component/componentLinking.dart';

class Component {

  Element initialElement;

  Component(this.initialElement, String htmlContent){
    _fillHtmlContent(htmlContent);
  }

  void onInit(){}

  void _fillHtmlContent(String htmlContent){
    initialElement.setInnerHtml(htmlContent);
  }

  void ensureRefresh(){
    ComponentLinking.refresh();
  }

}