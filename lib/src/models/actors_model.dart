class Cast {
  List<Actor> actors = new List();

  Cast.fromJsonList(List<dynamic> jsonList) {
    if(jsonList == null) return;

    jsonList.forEach((item) {
      final actor = Actor.fromJsonMap(item);
      actors.add(actor);
    });
  }
}

class Actor {
  Actor({
    this.adult,
    this.gender,
    this.id,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
    this.castId,
    this.character,
    this.creditId,
    this.order,
    this.job,
  });

  bool adult;
  int gender;
  int id;
  String name;
  String originalName;
  double popularity;
  String profilePath;
  int castId;
  String character;
  String creditId;
  int order;
  String job;

  Actor.fromJsonMap(Map<String, dynamic> json) {
    adult = json["adult"];
    gender = json["gender"];
    id = json["id"];
    name = json["name"];
    originalName = json["original_name"];
    popularity = json["popularity"].toDouble();
    profilePath = json["profile_path"] == null ? null : json["profile_path"];
    castId = json["cast_id"] == null ? null : json["cast_id"];
    character = json["character"] == null ? null : json["character"];
    creditId = json["credit_id"];
    order = json["order"] == null ? null : json["order"];
    job = json["job"] == null ? null : json["job"];
  }

  getActorImg() => profilePath == null
      ? 'https://r9b7u4m2.stackpathcdn.com/prod/sites/eXfkOOiYH-uoddxClSi52viuasTF1mJ8olZ0u-tOtfFqK66gZCc90Ly_Uoc0VmR1eULwQ0uGf2JhPt4yPTts8A/themes/base/assets/images/avatar-1.png'
      : 'https://image.tmdb.org/t/p/w500/$profilePath';
}

