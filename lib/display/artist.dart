library lastfmStats.artist;

import 'dart:html';
import 'dart:convert';

class Artist {

  static double delay = 0.0;

  static double _incrementDelay() {
    double temp = delay;
    delay += 0.03;
    return temp;
  }

  String name;
  String playcount;
  List images;
  String choosedImageUrl;

  Artist(Map json){
    print(json);
    name = json['name'];
    playcount = json['playcount'];
    images = json['image'];
    if (images != null) {
      for (int i = 0; i < images.length; i++) {
        if (images[i]['size'] == "large") {
          choosedImageUrl = images[i]['#text'];
          break;
        }
      }
    }
  }

  DivElement createDiv(){
    DivElement artistdiv = new DivElement();
    artistdiv.classes.add("artist");
    DivElement content = new DivElement();
    content.classes..add("content");
    content.style.animationDelay = "${_incrementDelay()}s";
    artistdiv..append(content..append(_metadataDiv())..append(_imageDiv()))..append(_blankCoverDiv());
    return artistdiv;
  }

  DivElement _metadataDiv(){
    DivElement metadataWrapperDiv = new DivElement();
    metadataWrapperDiv.classes.add("metadataWrapper");
    DivElement namediv = new DivElement();
    namediv.classes.add("name");
    DivElement playcountdiv = new DivElement();
    playcountdiv.classes.add("playCount");
    namediv.text = this.name;
    playcountdiv.text = this.playcount.toString();
    return metadataWrapperDiv..append(namediv)..append(playcountdiv);
  }

  DivElement _imageDiv(){
    DivElement imageWrapperDiv = new DivElement();
    imageWrapperDiv.classes.add("imageWrapper");
    DivElement imageDiv = new DivElement();
    imageDiv.classes.add("image");
    imageDiv.style.backgroundImage = 'url("$choosedImageUrl")';
    return imageWrapperDiv..append(imageDiv);
  }

  DivElement _blankCoverDiv(){
    DivElement blankDiv = new DivElement();
    blankDiv.classes.add("blankCover");
    return blankDiv;
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