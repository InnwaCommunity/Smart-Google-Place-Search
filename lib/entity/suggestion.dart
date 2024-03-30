class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      json['placeId'] as String,
      json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'description': description,
    };
  }
}
