enum Sorting { chronological, none }

class ConfigModel {
  ConfigModel({
    this.pin,
    this.securityQuestionOne,
    this.securityAnswerOne,
    this.securityQuestionTwo,
    this.securityAnswerTwo,
    this.currency,
    this.settings,
  });
  String? pin;
  String? securityQuestionOne;
  String? securityAnswerOne;
  String? securityQuestionTwo;
  String? securityAnswerTwo;
  CurrencyModel? currency;
  SettingsModel? settings;

  Map<String, dynamic> toJson() => {
        "pin": pin,
        "securityQuestionOne": securityQuestionOne,
        "securityAnswerOne": securityAnswerOne,
        "securityQuestionTwo": securityQuestionTwo,
        "securityAnswerTwo": securityAnswerTwo,
        "currency": currency == null
            ? null
            : CurrencyModel(
                country: currency!.country,
                currencyCode: currency!.currencyCode,
                symbol: currency!.symbol,
              ).toJson(),
        "settings": settings == null
            ? SettingsModel(
                sorting: Sorting.none.name,
                lastBackedUp: null,
              )
            : SettingsModel(
                sorting: settings!.sorting,
                lastBackedUp: settings!.lastBackedUp,
              )
      };
  factory ConfigModel.fromJson(Map<String, dynamic>? json) => ConfigModel(
        pin: json == null ? null : json["pin"],
        securityQuestionOne: json == null ? null : json["securityQuestionOne"],
        securityAnswerOne: json == null ? null : json["securityAnswerOne"],
        securityQuestionTwo: json == null ? null : json["securityQuestionTwo"],
        securityAnswerTwo: json == null ? null : json["securityAnswerTwo"],
        currency: json == null
            ? null
            : json['currency'] == null
                ? null
                : CurrencyModel.fromJson(json["currency"]),
        settings: json == null
            ? null
            : json['settings'] == null
                ? SettingsModel.fromJson({"sorting": Sorting.none.name})
                : SettingsModel.fromJson(json["settings"]),
      );

  ConfigModel copyWith({
    String? pin,
    String? securityQuestionOne,
    String? securityAnswerOne,
    String? securityQuestionTwo,
    String? securityAnswerTwo,
    CurrencyModel? currency,
    SettingsModel? settings,
  }) {
    return ConfigModel(
      pin: pin ?? this.pin,
      securityQuestionOne: securityQuestionOne ?? this.securityQuestionOne,
      securityAnswerOne: securityAnswerOne ?? this.securityAnswerOne,
      securityQuestionTwo: securityQuestionTwo ?? this.securityQuestionTwo,
      securityAnswerTwo: securityAnswerTwo ?? this.securityAnswerTwo,
      currency: currency ?? this.currency,
      settings: settings ?? this.settings,
    );
  }
}

class CurrencyModel {
  CurrencyModel({
    this.country,
    this.currencyCode,
    this.symbol,
  });
  String? country;
  String? currencyCode;
  String? symbol;

  Map<String, dynamic> toJson() =>
      {"country": country, "currencyCode": currencyCode, "symbol": symbol};

  factory CurrencyModel.fromJson(Map<String, dynamic>? json) => CurrencyModel(
      country: json == null ? null : json["country"],
      currencyCode: json == null ? null : json["currencyCode"],
      symbol: json == null ? null : json["symbol"]);

  CurrencyModel copyWith({
    String? country,
    String? currencyCode,
    String? symbol,
  }) {
    return CurrencyModel(
      country: country ?? this.country,
      currencyCode: currencyCode ?? this.currencyCode,
      symbol: symbol ?? this.symbol,
    );
  }
}

class SettingsModel {
  String sorting;
  String? lastBackedUp;
  SettingsModel({
    this.sorting = 'none',
    this.lastBackedUp,
  });

  SettingsModel copyWith({
    String? sorting,
    String? lastBackedUp,
  }) {
    return SettingsModel(
      sorting: sorting ?? this.sorting,
      lastBackedUp: lastBackedUp ?? this.lastBackedUp,
    );
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        sorting: json["sorting"],
        lastBackedUp: json["lastBackup"],
      );

  Map<String, dynamic> toJson() => {
        "sorting": sorting,
        "lastBackedUp": lastBackedUp,
      };
}
