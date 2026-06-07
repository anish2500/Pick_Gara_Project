import 'package:equatable/equatable.dart';

class RoomEntity extends Equatable {
  final String? roomId;
  final String name;
  final String category;
  final String pin;
  final String hostId;
  final List<String> members;
  final String status;

  const RoomEntity({
    this.roomId,
    required this.name,
    required this.category,
    required this.pin,
    required this.hostId,
    required this.members,
    required this.status,
  });

  @override
  List<Object?> get props => [
    roomId,
    name,
    category,
    pin,
    hostId,
    members,
    status,
  ]; 
}
