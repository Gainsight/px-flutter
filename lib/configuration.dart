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
        this.collectDeviceId = true});

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
        collectDeviceId = json['collectDeviceId'],
        proxy = json['proxy'],
        host = json['host'];

  final String? apiKey;
  int flushInterval = 30;
  int flushQueueSize = 20;
  int maxQueueSize = 1000;
  bool enableLogs = false;
  bool trackApplicationLifeCycleEvents = true;
  bool shouldTrackTapEvents = false;
  bool reportTrackingIssues = false;
  bool enable = true;
  bool collectDeviceId = true;
  String? proxy;
  PXHost? host;

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
      'collectDeviceId': collectDeviceId,
      'proxy': proxy,
      // ignore: prefer_null_aware_operators
      'host': host?.name
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
