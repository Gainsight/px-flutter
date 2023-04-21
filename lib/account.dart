class Account {
  Account(this.id,
      {this.name,
        this.trackedSubscriptionId,
        this.industry,
        this.numberOfEmployees,
        this.sicCode,
        this.website,
        this.naicsCode,
        this.plan,
        this.sfdcId,
        this.countryCode,
        this.countryName,
        this.stateCode,
        this.stateName,
        this.city,
        this.street,
        this.continent,
        this.postalCode,
        this.regionName,
        this.timeZone,
        this.latitude,
        this.longitude,
        this.customAttributes});

  Account.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        trackedSubscriptionId = json['trackedSubscriptionId'],
        industry = json['industry'],
        numberOfEmployees = json['numberOfEmployees'],
        sicCode = json['sicCode'],
        website = json['website'],
        naicsCode = json['naicsCode'],
        plan = json['plan'],
        sfdcId = json['sfdcId'],
        countryCode = json['countryCode'],
        countryName = json['countryName'],
        stateCode = json['stateCode'],
        stateName = json['stateName'],
        city = json['city'],
        street = json['street'],
        continent = json['continent'],
        postalCode = json['postalCode'],
        regionName = json['regionName'],
        timeZone = json['timeZone'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        customAttributes = json['customAttributes'];

  final String id;
  String? name;
  String? trackedSubscriptionId;
  String? industry;
  num? numberOfEmployees;
  String? sicCode;
  String? website;
  String? naicsCode;
  String? plan;
  String? sfdcId;
  String? countryCode;
  String? countryName;
  String? stateCode;
  String? stateName;
  String? city;
  String? street;
  String? continent;
  String? postalCode;
  String? regionName;
  String? timeZone;
  num? latitude;
  num? longitude;
  Map<String, dynamic>? customAttributes;

  dynamic toJson() {
    final Map<String, dynamic> jsonObj = {'id': id,
      'name': name,
      'trackedSubscriptionId': trackedSubscriptionId,
      'industry': industry,
      'numberOfEmployees': numberOfEmployees,
      'sicCode': sicCode,
      'website': website,
      'naicsCode': naicsCode,
      'plan': plan,
      'sfdcId': sfdcId,
      'countryCode': countryCode,
      'countryName': countryName,
      'stateCode': stateCode,
      'stateName': stateName,
      'city': city,
      'street': street,
      'continent': continent,
      'postalCode': postalCode,
      'regionName': regionName,
      'timeZone': timeZone,
      'latitude': latitude,
      'longitude': longitude,
      'customAttributes': customAttributes}
      ..removeWhere((key, value) => value == null);
    return jsonObj;
  }
}