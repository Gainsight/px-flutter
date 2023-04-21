
class User {
  User(this.ide,
      { this.email,
        this.userHash,
        this.gender,
        this.firstName,
        this.lastName,
        this.signUpDate,
        this.title,
        this.role,
        this.subscriptionId,
        this.phone,
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
        this.organization,
        this.organizationEmployees,
        this.organizationRevenue,
        this.organizationIndustry,
        this.organizationSicCode,
        this.organizationDuns,
        this.accountId,
        this.firstVisitDate,
        this.score,
        this.sfdcContactId,
        this.customAttributes});

  User.fromJson(Map<String, dynamic> json)
      : ide = json['ide'],
        email = json['email'],
        userHash = json['userHash'],
        gender = json['gender'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        signUpDate = json['signUpDate'],
        title = json['title'],
        role = json['role'],
        subscriptionId = json['subscriptionId'],
        phone = json['phone'],
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
        organization = json['organization'],
        organizationEmployees = json['organizationEmployees'],
        organizationRevenue = json['organizationRevenue'],
        organizationIndustry = json['organizationIndustry'],
        organizationSicCode = json['organizationSicCode'],
        organizationDuns = json['organizationDuns'],
        firstVisitDate = json['firstVisitDate'],
        accountId = json['accountId'],
        score = json['score'],
        sfdcContactId = json['sfdcContactId'],
        customAttributes = json['customAttributes'];

  final String ide;
  String? email;
  String? userHash;
  String? gender;
  String? firstName;
  String? lastName;

  num? signUpDate;
  String? title;
  String? role;
  String? subscriptionId;
  String? phone;
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
  String? organization;
  String? organizationEmployees;
  String? organizationRevenue;
  String? organizationIndustry;
  String? organizationSicCode;
  num? organizationDuns;
  String? accountId;

  num? firstVisitDate;
  num? score;
  String? sfdcContactId;
  Map<String, dynamic>? customAttributes;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonObj = {'ide': ide,
      'email': email,
      'userHash': userHash,
      'gender': gender,
      'lastName': lastName,
      'firstName': firstName,
      'signUpDate': signUpDate,
      'title': title,
      'role': role,
      'subscriptionId': subscriptionId,
      'phone': phone,
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
      'organization': organization,
      'organizationEmployees': organizationEmployees,
      'organizationRevenue': organizationRevenue,
      'organizationIndustry': organizationIndustry,
      'organizationSicCode': organizationSicCode,
      'organizationDuns': organizationDuns,
      'firstVisitDate': firstVisitDate,
      'accountId': accountId,
      'score': score,
      'sfdcContactId': sfdcContactId,
      'customAttributes': customAttributes}
      ..removeWhere((key, value) => value == null);
    return jsonObj;
  }
}