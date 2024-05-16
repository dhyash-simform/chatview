class Reaction {
  Reaction({
    required this.reactions,
    required this.reactedUserIds,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) => Reaction(
        reactions: (json['reactions'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        reactedUserIds: (json['reactedUserIds'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
      );

  /// Provides list of reaction in single message.
  final List<String> reactions;

  /// Provides list of user who reacted on message.
  final List<String> reactedUserIds;

  Map<String, dynamic> toJson() => {
        'reactions': reactions,
        'reactedUserIds': reactedUserIds,
      };
}
