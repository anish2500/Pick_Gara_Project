import 'package:mero_choice_application/features/vote/domain/entities/vote_entity.dart';

class PlaceTallyApiModel {
  final String placeId;
  final int likes;
  final int dislikes;
  final int total;

  const PlaceTallyApiModel({
    required this.placeId,
    required this.likes,
    required this.dislikes,
    required this.total,
  });

  factory PlaceTallyApiModel.fromJson(Map<String, dynamic> json) {
    return PlaceTallyApiModel(
      placeId: json['_id'] as String,
      likes: json['likes'] as int,
      dislikes: json['dislikes'] as int,
      total: json['total'] as int,
    );
  }

  PlaceTallyEntity toEntity() => PlaceTallyEntity(
        placeId: placeId,
        likes: likes,
        dislikes: dislikes,
        total: total,
      );
}

class VoteStatsApiModel {
  final int membersVoted;
  final int totalMembers;
  final String display;
  final List<PlaceTallyApiModel> placeTallies;

  const VoteStatsApiModel({
    required this.membersVoted,
    required this.totalMembers,
    required this.display,
    this.placeTallies = const [],
  });

  factory VoteStatsApiModel.fromJson(Map<String, dynamic> json) {
    return VoteStatsApiModel(
      membersVoted: json['membersVoted'] as int,
      totalMembers: json['totalMembers'] as int,
      display: json['display'] as String,
      placeTallies: (json['placeTallies'] as List<dynamic>? ?? [])
          .map((t) => PlaceTallyApiModel.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }

  VoteStatsEntity toEntity() => VoteStatsEntity(
        membersVoted: membersVoted,
        totalMembers: totalMembers,
        display: display,
        placeTallies: placeTallies.map((t) => t.toEntity()).toList(),
      );
}
