import 'package:uuid/uuid.dart';
 
const _uuid = Uuid();
 
class Author {
  final String authorId;
  final String authorName;
 
  Author({
    String? authorId,
    required this.authorName,
  }) : authorId = authorId ?? _uuid.v4();
 
  @override
  String toString() => authorName;
 
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Author &&
          runtimeType == other.runtimeType &&
          authorId == other.authorId;
 
  @override
  int get hashCode => authorId.hashCode;
}

