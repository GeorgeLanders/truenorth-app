class UserData {
  String name;
  String? customAffirmation;
  List<String> goals;
  String mobilityPreference; // 'seated', 'low_impact', 'mix'
  int streak;
  int waterCups;
  int sleepHours;
  int movementMinutes;
  int nourishmentCount;
  String? moodToday;
  bool onboardingComplete;
  bool useAICoach;
  String? aiProxyUrl;
  bool showCalories;
  int calorieTarget;

  UserData({
    this.name = '',
    this.customAffirmation,
    this.goals = const [],
    this.mobilityPreference = 'mix',
    this.streak = 0,
    this.waterCups = 0,
    this.sleepHours = 0,
    this.movementMinutes = 0,
    this.nourishmentCount = 0,
    this.moodToday,
    this.onboardingComplete = false,
    this.useAICoach = false,
    this.aiProxyUrl,
    this.showCalories = false,
    this.calorieTarget = 2000,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'customAffirmation': customAffirmation,
    'goals': goals,
    'mobilityPreference': mobilityPreference,
    'streak': streak,
    'waterCups': waterCups,
    'sleepHours': sleepHours,
    'movementMinutes': movementMinutes,
    'nourishmentCount': nourishmentCount,
    'moodToday': moodToday,
    'onboardingComplete': onboardingComplete,
    'useAICoach': useAICoach,
    'aiProxyUrl': aiProxyUrl,
    'showCalories': showCalories,
    'calorieTarget': calorieTarget,
  };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    name: json['name'] as String? ?? '',
    customAffirmation: json['customAffirmation'] as String?,
    goals: (json['goals'] as List?)?.cast<String>() ?? [],
    mobilityPreference: json['mobilityPreference'] as String? ?? 'mix',
    streak: json['streak'] as int? ?? 0,
    waterCups: json['waterCups'] as int? ?? 0,
    sleepHours: json['sleepHours'] as int? ?? 0,
    movementMinutes: json['movementMinutes'] as int? ?? 0,
    nourishmentCount: json['nourishmentCount'] as int? ?? 0,
    moodToday: json['moodToday'] as String?,
    onboardingComplete: json['onboardingComplete'] as bool? ?? false,
    useAICoach: json['useAICoach'] as bool? ?? false,
    aiProxyUrl: json['aiProxyUrl'] as String?,
    showCalories: json['showCalories'] as bool? ?? false,
    calorieTarget: json['calorieTarget'] as int? ?? 2000,
  );

  UserData copyWith({
    String? name,
    String? customAffirmation,
    List<String>? goals,
    String? mobilityPreference,
    int? streak,
    int? waterCups,
    int? sleepHours,
    int? movementMinutes,
    int? nourishmentCount,
    String? moodToday,
    bool? onboardingComplete,
    bool? useAICoach,
    String? aiProxyUrl,
    bool? showCalories,
    int? calorieTarget,
  }) {
    return UserData(
      name: name ?? this.name,
      customAffirmation: customAffirmation ?? this.customAffirmation,
      goals: goals ?? this.goals,
      mobilityPreference: mobilityPreference ?? this.mobilityPreference,
      streak: streak ?? this.streak,
      waterCups: waterCups ?? this.waterCups,
      sleepHours: sleepHours ?? this.sleepHours,
      movementMinutes: movementMinutes ?? this.movementMinutes,
      nourishmentCount: nourishmentCount ?? this.nourishmentCount,
      moodToday: moodToday ?? this.moodToday,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      useAICoach: useAICoach ?? this.useAICoach,
      aiProxyUrl: aiProxyUrl ?? this.aiProxyUrl,
      showCalories: showCalories ?? this.showCalories,
      calorieTarget: calorieTarget ?? this.calorieTarget,
    );
  }
}
