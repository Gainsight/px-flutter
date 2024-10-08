class Configurations {
  Configurations(this.apiKey,
      {this.flushInterval = 30,
      this.flushQueueSize = 20,
      this.maxQueueSize = 1000,
      this.enableLogs = false,
      this.trackApplicationLifeCycleEvents = true,
      this.shouldTrackTapEvents = false,
      this.reportTrackingIssues = false,
      this.enable = true,
      this.host = PXHost.us});

  Configurations.fromJson(Map<String, dynamic> json)
      : apiKey = json['apiKey'],
        flushInterval = json['flushInterval'],
        flushQueueSize = json['flushQueueSize'],
        maxQueueSize = json['maxQueueSize'],
        enableLogs = json['enableLogs'],
        trackApplicationLifeCycleEvents =
            json['trackApplicationLifeCycleEvents'],
        shouldTrackTapEvents = json['shouldTrackTapEvents'],
        reportTrackingIssues = json['reportTrackingIssues'],
        enable = json['enable'],
        proxy = json['proxy'],
        host = json['host'];

  final String apiKey;
  int flushInterval;
  int flushQueueSize;
  int maxQueueSize;
  bool enableLogs;
  bool trackApplicationLifeCycleEvents;
  bool shouldTrackTapEvents;
  bool reportTrackingIssues;
  bool enable;
  String? proxy;
  PXHost host;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonObj = {
      'apiKey': apiKey,
      'flushQueueSize': flushQueueSize,
      'maxQueueSize': maxQueueSize,
      'flushInterval': flushInterval,
      'enableLogs': enableLogs,
      'trackApplicationLifeCycleEvents': trackApplicationLifeCycleEvents,
      'shouldTrackTapEvents': shouldTrackTapEvents,
      'reportTrackingIssues': reportTrackingIssues,
      'enable': enable,
      'proxy': proxy,
      'host': host.name
    }..removeWhere((key, value) => value == null);
    return jsonObj;
  }
}

enum PXHost {
  us,
  eu,
  us2,
}

extension PXHostExtension on PXHost? {
  String get name => describeEnum(this);
}

String describeEnum(Object? enumEntry) {
  final String description = enumEntry.toString();
  final int indexOfDot = description.indexOf('.');
  assert(
      indexOfDot != -1 && indexOfDot < description.length - 1, 'Invalid index');
  return description.substring(indexOfDot + 1);
}
