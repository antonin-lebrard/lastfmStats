library lastfmStats.cache;

import 'dart:html';
import 'dart:convert';
import 'dart:async';
import 'package:lastfmStats/cache/fetch.dart';
import 'package:lastfmStats/display/artist.dart';
import 'package:lastfmStats/display/loading.dart';
import 'package:lastfmStats/cache/datetime.dart';


class Cache {

  static Cache _singleton;

  Map pages = new Map();
  List<Artist> artists = new List();

  Stream onFetchComplete;
  StreamController _fetchComplete = new StreamController.broadcast();
  bool fetchComplete = false;
  Stream onCacheLoaded;
  StreamController _cacheLoaded = new StreamController.broadcast();
  bool cacheLoaded = false;

  factory Cache(){
    if (_singleton == null)
      _singleton = new Cache._internal();
    return _singleton;
  }

  Cache._internal(){
    onFetchComplete = _fetchComplete.stream;
    onCacheLoaded = _cacheLoaded.stream;
    new Loading();
  }

  load(){
    if (compareLastUpdateToNow().inDays > 5){
      onFetchComplete.listen((_)=>cache());
      cacheLoaded = true;
      fetch();
    }
    if (window.localStorage.containsKey('artistsCached')){
      List<String> artistsJson = JSON.decode(window.localStorage['artistsCached']);
      for (String s in artistsJson){
        artists.add(new Artist(JSON.decode(s)));
      }
      cacheLoaded = true;
      _cacheLoaded.add(null);
    }
  }

  fetch(){
    List<Artist> newList = new List();
    LastFMFetching.getArtists(newList).then((_) {
      if (cacheLoaded){
        artists = newList;
        fetchComplete = true;
        _fetchComplete.add(null);
      } else {
        onCacheLoaded.listen((_){
          artists = newList;
          fetchComplete = true;
          _fetchComplete.add(null);
        });
      }
    });
  }

  cache(){
    List<String> artistsJson = new List();
    for (Artist a in artists){
      artistsJson.add(a.toJSONString());
    }
    DateTimeSerializable now = new DateTimeSerializable.now();
    window.localStorage['lastUpdate'] = now.toJson();
    window.localStorage['artistsCached'] = JSON.encode(artistsJson);
  }

  Duration compareLastUpdateToNow(){
    Duration diff = new Duration(days:365);
    if (window.localStorage.containsKey('lastUpdate')){
      DateTime lastUpdate = DateTimeSerializable.fromJson(window.localStorage['lastUpdate']);
      DateTime now = new DateTime.now();
      diff = now.difference(lastUpdate);
    }
    return diff;
  }
}

