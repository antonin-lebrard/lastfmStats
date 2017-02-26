library lastfmStats.errorComponent;

import 'dart:html';
import 'dart:async';
import 'package:lastfmStats/component/component.dart';


class ErrorComponent extends Component {

  static String errorVisibleClass = "error-outer-visible";
  static String errorUpdateClass = "error-inner-update";

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

  Future<bool> displayUpdate(String message){
    Completer completer = new Completer();
    errorInner.innerHtml = message;
    errorOuter.classes.add(errorVisibleClass);
    errorInner.classes.add(errorUpdateClass);
    Timer cancelable = new Timer(new Duration(seconds: 3000), (){
      errorOuter.classes.remove(errorVisibleClass);
      errorInner.classes.remove(errorUpdateClass);
      completer.complete(false);
    });
    errorInner.onClick.listen((_){
      cancelable.cancel();
      errorOuter.classes.remove(errorVisibleClass);
      errorInner.classes.remove(errorUpdateClass);
      completer.complete(true);
    });
    return completer.future;
  }

}