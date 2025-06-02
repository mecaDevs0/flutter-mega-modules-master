import 'package:hive/hive.dart';

@HiveType(typeId: 3)
enum BankAccountPersonType {
  @HiveField(0)
  physical,
  @HiveField(1)
  legal
}
