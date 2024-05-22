class Reaction {
  Reaction({
    required this.reactions,
    required this.reactedUserIds,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    final reactions = <String>[];
    final reactionsList = json['reactions'] as List<dynamic>?;

    for (var i = 0; i < (reactionsList?.length ?? 0); i++) {
      final reaction = reactionsList![i]?.toString();
      if (reaction?.isEmpty ?? true) continue;
      reactions.add(reaction!);
    }

    final reactedUserIds = <String>[];
    final reactedUserIdList = json['reactedUserIds'] as List<dynamic>?;

    for (var i = 0; i < (reactedUserIdList?.length ?? 0); i++) {
      final reactedUserId = reactedUserIdList![i]?.toString();
      if (reactedUserId?.isEmpty ?? true) continue;
      reactedUserIds.add(reactedUserId!);
    }

    return Reaction(reactions: reactions, reactedUserIds: reactedUserIds);
  }

  /// Provides list of reaction in single message.
  final List<String> reactions;

  /// Provides list of user who reacted on message.
  final List<String> reactedUserIds;

  Map<String, dynamic> toJson() => {
        'reactions': reactions,
        'reactedUserIds': reactedUserIds,
      };
}
