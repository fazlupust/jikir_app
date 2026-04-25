class AppSettingsEntity {
  final bool vibration;
  final bool sound;
  final bool keepScreenOn;
  final bool milestoneAlerts;
  final String theme;
  final String language;
  final bool namazNotifications;

  AppSettingsEntity({
    required this.vibration,
    required this.sound,
    required this.keepScreenOn,
    required this.milestoneAlerts,
    required this.theme,
    required this.language,
    required this.namazNotifications,
  });

  factory AppSettingsEntity.defaultSettings() {
    return AppSettingsEntity(
      vibration: true,
      sound: false,
      keepScreenOn: false,
      milestoneAlerts: true,
      theme: 'dark',
      language: 'en',
      namazNotifications: false,
    );
  }

  AppSettingsEntity copyWith({
    bool? vibration,
    bool? sound,
    bool? keepScreenOn,
    bool? milestoneAlerts,
    String? theme,
    String? language,
    bool? namazNotifications,
  }) {
    return AppSettingsEntity(
      vibration: vibration ?? this.vibration,
      sound: sound ?? this.sound,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      milestoneAlerts: milestoneAlerts ?? this.milestoneAlerts,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      namazNotifications: namazNotifications ?? this.namazNotifications,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vibration': vibration,
      'sound': sound,
      'keepScreenOn': keepScreenOn,
      'milestoneAlerts': milestoneAlerts,
      'theme': theme,
      'language': language,
      'namazNotifications': namazNotifications,
    };
  }

  factory AppSettingsEntity.fromMap(Map<dynamic, dynamic> map) {
    return AppSettingsEntity(
      vibration: map['vibration'] ?? true,
      sound: map['sound'] ?? false,
      keepScreenOn: map['keepScreenOn'] ?? false,
      milestoneAlerts: map['milestoneAlerts'] ?? true,
      theme: map['theme'] ?? 'dark',
      language: map['language'] ?? 'en',
      namazNotifications: map['namazNotifications'] ?? false,
    );
  }
}
