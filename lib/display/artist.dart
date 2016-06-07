library lastfmStats.artist;

import 'dart:html';
import 'dart:convert';

class Artist {

  String name;
  int playCount;
  List images;

  Artist(Map json){
    name = json['name'];
    playCount = json['playCount'];
    images = json['image'];
  }

  DivElement createDiv(){
    DivElement artistdiv = new DivElement();
    artistdiv.classes.add("artist");
    DivElement namediv = new DivElement();
    namediv.classes.add("name");
    DivElement playcountdiv = new DivElement();
    playcountdiv.classes.add("playCount");
    namediv.text = this.name;
    playcountdiv.text = this.playCount.toString();
    artistdiv..append(namediv)..append(playcountdiv);
    return artistdiv;
  }

  String toString() => "$name : $playCount";

  String toJSONString(){
    return JSON.encode(
        new Map()
          ..putIfAbsent('name',      () => name)
          ..putIfAbsent('playCount', () => playCount)
          ..putIfAbsent('images',    () => images)
    );
  }

}