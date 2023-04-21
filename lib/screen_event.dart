
class ScreenEvent {
  ScreenEvent(this.screenName);

  ScreenEvent.fromJson(Map<String, dynamic> json)
      : screenName = json['screenName'],
        screenClass = json['screenClass'];

  final String screenName;
  String? screenClass;
}