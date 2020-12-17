class Recipe
{
  String label;
  String image;
  String source;
  String url;

  Recipe({this.label,this.image,this.source,this.url});
  factory Recipe.fromMap(Map<String,dynamic> parsedJson)
  {
    return Recipe(
      url:parsedJson["url"],
      image:parsedJson["image"],
      source:parsedJson["source"],
      label: parsedJson["label"]
    );
  }
}