import 'package:hive/hive.dart';
import '../config/constants.dart';

part 'settings.g.dart';

@HiveType(typeId: 5)
class AppSettings {
  @HiveField(0)
  final String userId;
  
  @HiveField(1)
  final double weeklyGoal;
  
  @HiveField(2)
  final String preferredFuelType;
  
  @HiveField(3)
  final Map<String, Map<String, double>> commissionRates;
  
  @HiveField(4)
  final String displayName;
  
  AppSettings({
    required this.userId,
    this.weeklyGoal = AppConstants.defaultWeeklyGoal,
    this.preferredFuelType = AppConstants.defaultFuelType,
    Map<String, Map<String, double>>? commissionRates,
    required this.displayName,
  }) : commissionRates = commissionRates ?? AppConstants.defaultCommissionRates;
  
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      userId: json['userId'] as String,
      weeklyGoal: (json['weeklyGoal'] as num?)?.toDouble() ?? AppConstants.defaultWeeklyGoal,
      preferredFuelType: json['preferredFuelType'] as String? ?? AppConstants.defaultFuelType,
      commissionRates: json['commissionRates'] != null
          ? Map<String, Map<String, double>>.from(
              (json['commissionRates'] as Map).map(
                (key, value) => MapEntry(
                  key as String,
                  Map<String, double>.from(value as Map),
                ),
              ),
            )
          : AppConstants.defaultCommissionRates,
      displayName: json['displayName'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'weeklyGoal': weeklyGoal,
      'preferredFuelType': preferredFuelType,
      'commissionRates': commissionRates,
      'displayName': displayName,
    };
  }
  
  AppSettings copyWith({
    String? userId,
    double? weeklyGoal,
    String? preferredFuelType,
    Map<String, Map<String, double>>? commissionRates,
    String? displayName,
  }) {
    return AppSettings(
      userId: userId ?? this.userId,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      preferredFuelType: preferredFuelType ?? this.preferredFuelType,
      commissionRates: commissionRates ?? this.commissionRates,
      displayName: displayName ?? this.displayName,
    );
  }
}
