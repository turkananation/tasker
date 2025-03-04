import 'package:hive/hive.dart';

part 'priority_level.g.dart';

@HiveType(typeId: 1)
enum PriorityLevel {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}
