library lastfmStats.artist;

import 'dart:html';
import 'dart:convert';
import 'dart:async';

class Artist {

  static double delay = 0.0;
  static bool isAlreadyListeningScroll = false;
  static bool _isScrolling = false;

  static void _resetDelay() {
    delay = 0.0;
  }

  static double _incrementDelay() {
    double temp = delay;
    delay += 0.03;
    if (delay > 1.5)
      _resetDelay();
    return temp;
  }

  String name;
  String playcount;
  List images;
  String chosenImageUrl;

  DivElement artistDiv;
  DivElement content;

  Artist(Map json){
    name = json['name'];
    playcount = json['playcount'];
    images = json['image'];
    if (images != null) {
      for (int i = 0; i < images.length; i++) {
        if (images[i]['size'] == "large") {
          chosenImageUrl = images[i]['#text'];
          break;
        }
      }
    }
    if (!isAlreadyListeningScroll){
      isAlreadyListeningScroll = true;
      window.onScroll.listen((_){
        if (!_isScrolling){
          _resetDelay();
          _isScrolling = true;
          new Timer(new Duration(milliseconds: 10), (){
            _isScrolling = false;
          });
        }
      });
    }
  }

  DivElement createDiv(){
    artistDiv = new DivElement();
    artistDiv.classes.add("artist");
    content = new DivElement();
    content.classes..add("content");
    content.style.animationDelay = "${_incrementDelay()}s";
    artistDiv..append(content..append(_metadataDiv())..append(_imageDiv()));
    return artistDiv;
  }

  DivElement _metadataDiv(){
    DivElement metadataWrapperDiv = new DivElement();
    metadataWrapperDiv.classes.add("metadataWrapper");
    DivElement nameDiv = new DivElement();
    nameDiv.classes.add("name");
    DivElement playCountDiv = new DivElement();
    playCountDiv.classes.add("playCount");
    nameDiv.text = this.name;
    playCountDiv.text = this.playcount.toString();
    return metadataWrapperDiv..append(nameDiv)..append(playCountDiv);
  }

  DivElement _imageDiv(){
    DivElement imageWrapperDiv = new DivElement();
    imageWrapperDiv.classes.add("imageWrapper");
    DivElement imageDiv = new DivElement();
    imageDiv.classes.add("image");
    imageDiv.style.backgroundImage = 'url("$chosenImageUrl")';
    return imageWrapperDiv..append(imageDiv);
  }

  String toString() => "$name : $playcount";

  String toJSONString(){
    return JSON.encode(
        new Map()
          ..putIfAbsent('name',      () => name)
          ..putIfAbsent('playcount', () => playcount)
          ..putIfAbsent('image',     () => images)
    );
  }

}