library lastfmStats.cache;

import 'dart:html';
import 'dart:convert';
import 'dart:async';
import 'package:lastfmStats/cache/fetch.dart';
import 'package:lastfmStats/display/artist.dart';
import 'package:lastfmStats/display/loading.dart';
import 'package:lastfmStats/cache/datetime.dart';


class Cache {

  static final String ARTISTS_KEY = "artistsCached";
  static final String UPDATE_KEY = "lastUpdate";
  static final String USERNAME_KEY = "lastUsername";

  static Cache _singleton;

  Map pages = new Map();
  List<Artist> artists = new List();

  Stream onFetchComplete;
  StreamController _fetchComplete = new StreamController.broadcast();
  bool fetchComplete = false;
  Stream onCacheLoaded;
  StreamController _onCacheLoaded = new StreamController.broadcast();
  bool _cacheLoaded = false;

  factory Cache(){
    if (_singleton == null)
      _singleton = new Cache._internal();
    return _singleton;
  }

  Cache._internal(){
    onFetchComplete = _fetchComplete.stream;
    onCacheLoaded = _onCacheLoaded.stream;
    new Loading(this);
  }

  bool get isCachedDataPresent => window.localStorage.containsKey(ARTISTS_KEY);
  bool get usernamePresent => window.localStorage.containsKey(USERNAME_KEY);
  bool get _lastUpdatePresent => window.localStorage.containsKey(UPDATE_KEY);

  load(){
    if (usernamePresent)
      LastFMFetching.user = window.localStorage[USERNAME_KEY];
    if (LastFMFetching.user == null || LastFMFetching.user == "")
      return;
    if (_compareLastUpdateToNow().inDays > 5){
      onFetchComplete.listen((_) {
        cache();
      });
      fetch();
    }
    if (isCachedDataPresent){
      List<String> artistsJson = JSON.decode(window.localStorage[ARTISTS_KEY]);
      for (String s in artistsJson){
        artists.add(new Artist(JSON.decode(s)));
      }
      _cacheLoaded = true;
      _onCacheLoaded.add(null);
    } else {
      _cacheLoaded = true;
    }
  }

  fetch(){
    List<Artist> newList = new List();
    LastFMFetching.getArtists(newList).then((_) {
      if (_cacheLoaded) {
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
    window.localStorage[UPDATE_KEY] = now.toJson();
    window.localStorage[ARTISTS_KEY] = JSON.encode(artistsJson);
    window.localStorage[USERNAME_KEY] = LastFMFetching.user;
  }

  Duration _compareLastUpdateToNow(){
    Duration diff = new Duration(days:365);
    if (_lastUpdatePresent){
      DateTime lastUpdate = DateTimeSerializable.fromJson(window.localStorage[UPDATE_KEY]);
      DateTime now = new DateTime.now();
      diff = now.difference(lastUpdate);
    }
    return diff;
  }
}

