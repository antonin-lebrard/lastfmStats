// Copyright (c) 2016, Antonin LEBRARD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:convert';
import 'dart:async';

String API_KEY = "e48114b86f19bf363d5dbc85397799e1";
String user = "fandegw";

DivElement output = querySelector("#output");
DivElement loading = querySelector("#loading");
Map pages = new Map();
List<Artist> artists = new List();

void main() {
  pages['totalPages'] = "2";
  getArtists(artists).then((List<Artist> a){
    artists = a;
    loading.style.display = 'none';
    for (Artist a in artists){
      output.append(a.createDiv());
    }
  });
}

Future<List<Artist>> getArtists(List<Artist> artists, [int page=0]){
  if (page >= int.parse(pages['totalPages'])){
    return new Future.value(artists);
  }
  Completer completer = new Completer();
  loading.text = ((page / int.parse(pages['totalPages'])) * 100).toString().substring(0,2) + "%";
  getArtistPage(page).then((List<Artist> artistsPage){
    artists.addAll(artistsPage);
    completer.complete(getArtists(artists, ++page));
  });
  return completer.future;
}

Future<List<Artist>> getArtistPage([int page = 0]){
  Completer<List<Artist>> completer = new Completer();
  List<Artist> artistsPage = new List();
  String url = "http://ws.audioscrobbler.com/2.0/?method=library.getartists&api_key=$API_KEY&user=$user&format=json";
  if (page > 0){
    url += "&page=$page";
  }
  new HttpRequest()..open("GET", url)..onLoad.listen((event){
    Map content = JSON.decode(event.target.responseText);
    content = content["artists"];
    pages = content["@attr"];
    List artistsContent = content["artist"];
    print(pages);
    for (Map artist in artistsContent){
      artistsPage.add(new Artist(artist));
    }
    completer.complete(artistsPage);
  })..send();
  return completer.future;
}


class Artist {

  String name;
  int playCount;
  List images;

  Artist(Map json){
    name = json['name'];
    playCount = int.parse(json['playcount']);
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

}