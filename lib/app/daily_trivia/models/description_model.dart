import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Description extends Equatable {
  final String id;
  final String description;
  final String countdownDate;

  const Description({
    required this.id,
    required this.description,
    required this.countdownDate,
  });

  @override
  List<Object> get props => [
    id,
    description,
    countdownDate,
  ];

  @override
  bool get stringify => true;

  factory Description.fromMap(Map<String, dynamic> map, String id) {
    return Description(
      id: id,
      description: map['description'] ?? '',
      countdownDate: map['countdownDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'countdownDate': countdownDate,
    };
  }
}

