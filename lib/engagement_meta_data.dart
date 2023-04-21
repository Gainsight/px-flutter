class EngagementMetaData {
  EngagementMetaData(this.engagementId, this.engagementName, this.scope,
      this.params, this.actionText, this.actionData, this.actionType);

  final String? engagementId;
  final String? engagementName;
  final Map? scope;
  final Map? params;
  final String? actionText;
  final String? actionData;
  final String? actionType;

  @override
  String toString() {
    return "EngagementMetaData{engagementId=$engagementId, engagementName=$engagementName, scope=${scope!['screenName']} + ${scope!['screenClass']}, actionText=$actionText, actionData=$actionData, actionType=$actionType}";
  }
}
