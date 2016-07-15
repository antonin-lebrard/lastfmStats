library lastfmStats.errorComponent;

import 'dart:html';
import 'dart:async';
import 'package:lastfmStats/component/component.dart';


class ErrorComponent extends Component {

  static String errorVisibleClass = "error-outer-visible";

  static String htmlContent =
  '''
  <div class="error-outer">
        <div class="error-inner">Error</div>
  </div>
  ''';

  Element errorInner;
  Element errorOuter;

  ErrorComponent(Element elem)
    : super(elem, htmlContent)
  {
    errorInner = elem.querySelectorAll(".error-inner")[0];
    errorOuter = elem.querySelectorAll(".error-outer")[0];
  }

  displayError(String message){
    errorInner.innerHtml = message;
    errorOuter.classes.add(errorVisibleClass);
    new Timer(new Duration(seconds: 5), (){
      errorOuter.classes.remove(errorVisibleClass);
    });
  }

}