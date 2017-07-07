library lastfm.searchUrl;




class SearchUrlHelper {

  static String googlePlayMusicSearchUrl = "https://play.google.com/music/listen?u=0#/sr/";
  static String deezerSearchUrl = "http://www.deezer.com/search/";
  static String spotifySearchUrl = "https://open.spotify.com/search/results/";

  static String searchGoogleMusic(String searchTerms){
    List<String> toEncode = searchTerms.split(" ");
    toEncode = toEncode.map<String>((String s) => Uri.encodeFull(s)).toList(growable: false);
    String search = toEncode.join("+");
    return googlePlayMusicSearchUrl + search;
  }

  static String searchDeezer(String searchTerms){
    return deezerSearchUrl + Uri.encodeFull(searchTerms);
  }

  static String searchSpotify(String searchTerms){
    return spotifySearchUrl + Uri.encodeFull(searchTerms);
  }

}