library lastfmStats.fetch;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:lastfmStats/display/artist.dart';

class LastFMFetching {

  static String API_KEY = "e48114b86f19bf363d5dbc85397799e1";
  String user = "";

  StreamController<int> _loading = new StreamController.broadcast();
  Stream<int> loading;
  StreamController<LastFMError> _onError = new StreamController.broadcast();
  Stream<LastFMError> onError;

  Map attr = {
    "totalPages": "2",
    "isFake": true
  };

  LastFMFetching(){
    loading = _loading.stream;
    onError = _onError.stream;
  }

  Future<List<Artist>> getArtists(List<Artist> artists, [int page=1]){
    if (page > int.parse(attr['totalPages'])){
      return new Future.value(artists);
    }
    Completer completer = new Completer();
    if (attr['isFake'] == null || !attr['isFake']){
      int loadingPercentage = ((page / int.parse(attr['totalPages'])) * 100).toInt();
      _loading.add(loadingPercentage);
    }
    getArtistPage(page).then((List<Artist> artistsPage){
      artists.addAll(artistsPage);
      _loading.add(100);
      completer.complete(getArtists(artists, ++page));
    }).catchError((LastFMError error){
      _onError.add(error);
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
      if (content.containsKey("error")){
        print(content);
        return completer.completeError(new LastFMError(content["error"], content["message"]));
      }
      content = content["artists"];
      attr = content["@attr"];
      List artistsContent = content["artist"];
      print(attr);
      for (Map artist in artistsContent){
        artistsPage.add(new Artist(artist));
      }
      completer.complete(artistsPage);
    })..send();
    return completer.future;
  }

}

class LastFMError {
  int code;
  String message;
  LastFMError(this.code, this.message);
  toString() => "$code : $message";
}