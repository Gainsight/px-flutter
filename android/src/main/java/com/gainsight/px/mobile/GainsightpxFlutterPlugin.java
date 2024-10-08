package com.gainsight.px.mobile;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Point;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Handler;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterSurfaceView;
import io.flutter.embedding.android.FlutterTextureView;
import io.flutter.embedding.android.RenderMode;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.JSONUtil;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * GainsightpxFlutterPlugin
 */
public class GainsightpxFlutterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  public static final String ERROR_CODE = "error";
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private Activity activity;
  private static final String KEY_ENABLE = "enable";
  private static final String KEY_PROPERTIES = "properties";
  private static final String TAG = "GainsightPX";
  private Handler mainHandler = null;
  private boolean shouldBuildDOM = false;
  private boolean isTrackScrollChange = false;
  private UIDelegate.Callback<JSONObject> DOMBuildercallback = null;
  private UIDelegate.Callback<Boolean> scrollStateCallback = null;
  private String renderViewClass;
  private UIDelegate.InteractionReport tapListener;
  private final UIDelegate delegate = new UIDelegate() {
    @Override
    public void startTrackingUserInteractions(InteractionReport interactionReport, Activity activity) {
      tapListener = interactionReport;
    }

    @Override
    public String getContainerViewClass() {
      return renderViewClass;
    }

    @Override
    public void getViewAtPosition(Point point, final UIDelegate.Callback<TreeBuilder> callback) {
      try {
        HashMap<String, Object> params = new HashMap<>();
        params.put("x", (double) point.x);
        params.put("y", (double) point.y);
        params.put("global", true);
        channel.invokeMethod("getViewAtPosition", params, new SafeResult(new Result() {
          @Override
          @SuppressWarnings("unchecked")
          public void success(@Nullable Object result) {
            try {
              Map<String, Object> properties = (Map<String, Object>) result;
              String tappedView = (String) properties.get("tappedView");
              if (null == tappedView) {
                tappedView = (String) properties.get("renderViewClass");
                if (null == tappedView) {
                  tappedView = (String) properties.get("className");
                }
              }
              List<Map> viewElements = (List<Map>) properties.get("viewElements");
              Map<String, Object> rect = (Map<String, Object>) properties.get("rect");
              callback.onResponse(new FlutterTreeBuilder(tappedView, viewElements, rect));
            } catch (Exception e) {
              callback.onError(e);
            }
          }

          @Override
          public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
            callback.onError(new Exception(errorMessage));
          }

          @Override
          public void notImplemented() {
            callback.onError(null);
          }
        }));
      } catch (Exception error) {
        callback.onError(error);
      }
    }

    @Override
    public void startDomBuilder(final Callback<JSONObject> callback) {
      shouldBuildDOM = true;
      DOMBuildercallback = callback;
      buildDOM();
    }

    @Override
    public void stopDomBuilder() {
      shouldBuildDOM = false;
      DOMBuildercallback = null;
    }

    @Override
    public void startScrollListener(Callback<Boolean> callback) {
      scrollStateCallback = callback;
      isTrackScrollChange = true;
    }

    @Override
    public void stopScrollListener() {
      scrollStateCallback = null;
      isTrackScrollChange = false;
    }

    @Override
    public void getViewPosition(final JSONObject jsonObject, final Callback<Rect> callback) {
      if (null != mainHandler) {
        mainHandler.post(new Runnable() {
          @Override
          public void run() {
            try {
              HashMap<String, Object> params = new HashMap<>();
              params.put("viewElements", JSONUtil.unwrap(jsonObject.get("viewElements")));
              params.put("type", JSONUtil.unwrap(jsonObject.get("type")));
              params.put("global", true);
              channel.invokeMethod("getViewPosition", params, new SafeResult(new Result() {
                @Override
                @SuppressWarnings("unchecked")
                public void success(@Nullable Object result) {
                  try {
                    List<Map<String, Object>> properties = (List<Map<String, Object>>) result;
                    if ((null != properties) && (!properties.isEmpty())) {
                      Map<String, Object> rectMap = properties.get(0);
                      if (null != rectMap) {
                        int x = FlutterTreeBuilder.getAsInt(rectMap.get("x"));
                        int y = FlutterTreeBuilder.getAsInt(rectMap.get("y"));
                        final Rect resultRect = new Rect(x, y, x + FlutterTreeBuilder.getAsInt(rectMap.get("width")), y + FlutterTreeBuilder.getAsInt(rectMap.get("height")));
                        callback.onResponse(resultRect);
                        return;
                      }
                    }
                    callback.onError(new NullPointerException("View not found"));
                  } catch (final Exception e) {
                    callback.onError(e);
                  }
                }

                @Override
                public void error(String errorCode, @Nullable final String errorMessage, @Nullable Object errorDetails) {
                  callback.onError(new Exception(errorMessage));
                }

                @Override
                public void notImplemented() {
                  callback.onError(null);
                }
              }));
            } catch (final Exception error) {
              callback.onError(error);
            }
          }
        });
      } else {
        callback.onError(new IllegalStateException("Needs to run on UIThread"));
      }
    }
  };
  private final GainsightPX.EngagementCallback engagementCallback = new GainsightPX.EngagementCallback() {
    @Override
    public boolean onCallback(final EngagementMetaData engagementMetaData) {
      if (mainHandler != null && null != engagementMetaData) {
        mainHandler.post(new Runnable() {
          @Override
          public void run() {
            try {
              HashMap<String, Object> params = new HashMap<>();
              params.put("actionData", engagementMetaData.actionData);
              params.put("actionText", engagementMetaData.actionText);
              params.put("actionType", engagementMetaData.actionType);
              params.put("engagementId", engagementMetaData.engagementId);
              params.put("engagementName", engagementMetaData.engagementName);
              params.put("scope", engagementMetaData.scope);
              params.put("params", engagementMetaData.params);
              channel.invokeMethod("onEngagementCallback", params);
            } catch (Exception error) {

            }
          }
        });
      }
      return true;
    }
  };

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "gainsightpx");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "gainsightpx_flutter_plugin");
    channel.setMethodCallHandler(new GainsightpxFlutterPlugin());
  }

  @Override
  @SuppressWarnings("unchecked")
  public void onMethodCall(@NonNull MethodCall call, @NonNull final Result tempResult) {
    SafeResult result = new SafeResult(tempResult);
    switch (call.method) {
      case "flutterViewChanged":
        buildDOM();
        break;
      case "scrollStateChanged":
        trackScrollStateChange((Map<String, Object>) call.arguments);
        break;
      case "initialise":
        initialize((Map<String, Object>) call.arguments, result);
        break;
      case "identifyWithID":
      case "identifyWithUser":
      case "identifyWithUserAndAccount":
        identify((Map<String, Object>) call.arguments, result);
        break;
      case "customEvent":
      case "customEventWithProperties":
        custom((Map<String, Object>) call.arguments, result);
        break;
      case "screenEventWithTitle":
      case "screenEventWithProperties":
      case "screenEventWithTitleAndProperties":
        screen((Map<String, Object>) call.arguments, result);
        break;
      case "setGlobalContext":
        setGlobalContext((Map<String, Object>) call.arguments, result);
        break;
      case "hasGlobalKey":
        hasGlobalContextKey((Map<String, Object>) call.arguments, result);
        break;
      case "removeGlobalContextKeys":
        removeGlobalContextKeys((Map<String, Object>) call.arguments, result);
        break;
      case "enable":
        enableDisable(true, result);
        break;
      case "disable":
        enableDisable(false, result);
        break;
      case "flush":
        flush(result);
        break;
      case "trackTaps":
        reportTap((Map<String, Object>) call.arguments, result);
        break;
      case "enterEditing":
        enterEditing((Map<String, Object>)call.arguments,result);
        break;
      case "exitEditing":
        exitEditing(result);
        break;
      case "reset":
        reset(result);
        break;
      case "hardReset":
        hardReset(result);
        break;
      case "enableEngagements":
        enableEngagements((Map<String, Object>)call.arguments, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    context = null;
  }

  private void trackScrollStateChange(Map<String, Object> map) {
    if (null != scrollStateCallback && isTrackScrollChange && map != null) {
      try {
        boolean scrollState = (boolean) map.get("scrollState");
        if (scrollState) {
          scrollStateCallback.onResponse(true);
        } else {
          if (mainHandler != null && null != DOMBuildercallback && shouldBuildDOM) {
            mainHandler.post(new Runnable() {
              @Override
              public void run() {
                try {
                  channel.invokeMethod("createDOMStructure", null, new Result() {
                    @Override
                    @SuppressWarnings("unchecked")
                    public void success(@Nullable Object result) {
                      try {
                        Map<String, Object> componentsTree = (Map<String, Object>) result;
                        if (null != componentsTree) {
                          JSONObject container = new JSONObject();
                          container.put("id", delegate.getContainerViewClass());
                          JSONArray array = new JSONArray();
                          array.put(new ValueMap(componentsTree).toJsonObject());
                          container.put("componentTree", array);
                          DOMBuildercallback.onResponse(container);
                          scrollStateCallback.onResponse(false);
                        } else {
                          DOMBuildercallback.onError(new NullPointerException("Unable to build DOM"));
                        }
                      } catch (Exception e) {
                        DOMBuildercallback.onError(e);
                      }
                    }

                    @Override
                    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                      DOMBuildercallback.onError(new Exception(errorMessage));
                    }

                    @Override
                    public void notImplemented() {
                      DOMBuildercallback.onError(null);
                    }
                  });
                } catch (Exception error) {
                  DOMBuildercallback.onError(error);
                }
              }
            });
          }
        }
      } catch (Exception e) {

      }
    }
  }

  private void buildDOM() {
    if (null != DOMBuildercallback && shouldBuildDOM) {
      if (null != mainHandler) {
        mainHandler.post(new Runnable() {
          @Override
          public void run() {
            try {
              channel.invokeMethod("createDOMStructure", null, new SafeResult(new Result() {
                @Override
                @SuppressWarnings("unchecked")
                public void success(@Nullable Object result) {
                  try {
                    Map<String, Object> componentsTree = (Map<String, Object>) result;
                    if (null != componentsTree) {
                      JSONObject container = new JSONObject();
                      container.put("id", delegate.getContainerViewClass());
                      JSONArray array = new JSONArray();
                      array.put(new ValueMap(componentsTree).toJsonObject());
                      container.put("componentTree", array);
                      DOMBuildercallback.onResponse(container);
                    } else {
                      DOMBuildercallback.onError(new NullPointerException("Unable to build DOM"));
                    }
                  } catch (Exception e) {
                    DOMBuildercallback.onError(e);
                  }
                }

                @Override
                public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                  DOMBuildercallback.onError(new Exception(errorMessage));
                }

                @Override
                public void notImplemented() {
                  DOMBuildercallback.onError(null);
                }
              }));
            } catch (Exception error) {
              DOMBuildercallback.onError(error);
            }
          }
        });
      } else {
        DOMBuildercallback.onError(new IllegalStateException("Needs to run on UIThread"));
      }
    }
  }

  private void initialize(Map<String, Object> configuration, final Result result) {
    try {
      if (configuration != null && configuration.containsKey("apiKey")) {
        Context ctx = this.context;
        if (activity != null) {
          ctx = activity;
        }
        String apiKey = (String) configuration.get("apiKey");
        apiKey += ",FLU";
        GainsightPX.Builder builder = new GainsightPX.Builder(ctx, apiKey, new GainsightPX.ExceptionHandler() {
          @Override
          public void onExceptionOccurred(String methodName, ValueMap params, String exceptionMessage) {
            result.error(methodName, exceptionMessage, params);
          }
        });
        Boolean shouldTrackTapEvents = (Boolean) configuration.get("shouldTrackTapEvents");
        if (shouldTrackTapEvents != null) {
          builder.shouldTrackTapEvents(shouldTrackTapEvents);
        }
        if (configuration.containsKey("maxQueueSize")) {
          int maxQueueSize = (int) configuration.get("maxQueueSize");
          builder.maxQueueSize(maxQueueSize);
        }
        if (configuration.containsKey("flushQueueSize")) {
          int flushQueueSize = (int) configuration.get("flushQueueSize");
          builder.flushQueueSize(flushQueueSize);
        }
        if (configuration.containsKey("flushInterval")) {
          int flushInterval = (int) configuration.get("flushInterval");
          builder.flushInterval(flushInterval, TimeUnit.SECONDS);
        }
        if (configuration.containsKey("enableLogs")) {
          Object object = configuration.get("enableLogs");
          boolean outputLogs = false;
          if (object instanceof Boolean) {
            outputLogs = (Boolean) object;
          }
          if (outputLogs) {
            builder.logLevel(LogLevel.VERBOSE);
          } else {
            builder.logLevel(LogLevel.NONE);
          }
        }
        Boolean trackApplicationLifeCycleEvents = (Boolean) configuration.get("trackApplicationLifeCycleEvents");
        if (trackApplicationLifeCycleEvents != null) {
          builder.trackApplicationLifecycleEvents(trackApplicationLifeCycleEvents);
        }
        builder.recordScreenViews(false);
        Boolean reportTrackingIssues = (Boolean) configuration.get("reportTrackingIssues");
        if (reportTrackingIssues != null) {
          builder.shouldReportIssuesToServer(reportTrackingIssues);
        }
        if (configuration.containsKey("proxy")) {
          builder.proxy((String) configuration.get("proxy"));
        } else if (configuration.containsKey("host")) {
          String host = (String) configuration.get("host");
          builder.pxHost(host);
        }

        Boolean isEngagementCallback = (Boolean) configuration.get("engagementCallback");
        if (engagementCallback != null && isEngagementCallback != null && isEngagementCallback) {
          builder.engagementCallback(engagementCallback);
        }

        GainsightPX instance;
        try {
          instance = builder.build();
        } catch (IllegalStateException e) {
          if (e.getMessage().contains("Duplicate gainsightPX client created with tag")) {
            instance = GainsightPX.with(ctx);
          } else {
            throw e;
          }
        }
        Boolean enable = (Boolean) configuration.get(KEY_ENABLE);
        if (enable != null) {
          instance.setEnable(enable);
        }
        try {
          GainsightPX.setSingletonInstance(instance);
        } catch (IllegalStateException e) {
          if (!(e.getMessage().contains("Singleton instance already exists."))) {
            throw e;
          }
        }
        instance.addUiDelegate(this.delegate);
        result.success("initialize");
      } else {
        result.error(ERROR_CODE, "Configuration cant be null", configuration);
      }
    } catch (Throwable tr) {
      result.error(ERROR_CODE, tr.getMessage(), tr);
      Log.e(TAG, "initialize: ", tr);
    }
  }

  @SuppressWarnings("unchecked")
  private void identify(Map<String, Object> properties, final Result result) {
    try {
      User nativeUser = null;
      Account nativeAccount = null;
      if (properties.containsKey("userID")) {
        String userID = (String) properties.get("userID");
        nativeUser = new User(userID);
      } else {
        if (properties.containsKey("user")) {
          Map<String, Object> user = (Map<String, Object>) properties.get("user");
          if (user != null) {
            nativeUser = new User((String) user.get("ide"));
            nativeUser.putAll(user);
          }
        }
        if (properties.containsKey("account")) {
          Map<String, Object> account = (Map<String, Object>) properties.get("account");
          if (account != null) {
            nativeAccount = new Account((String) account.get("id"));
            nativeAccount.putAll(account);
          }
        }
      }
      if (nativeUser != null) {
        GainsightPX.with(context).identify(nativeUser, nativeAccount, new GainsightPX.ExceptionHandler() {
          public void onExceptionOccurred(String methodName, ValueMap params, String exceptionMessage) {
            result.error(methodName, exceptionMessage, params);
          }
        });
        result.success("identify");
      } else {
        result.error(ERROR_CODE, "User id must not be null", properties);
      }
    } catch (Throwable tr) {
      result.error(ERROR_CODE, tr.getMessage(), tr);
      Log.e(TAG, "identify: ", tr);
    }
  }

  @SuppressWarnings("unchecked")
  private void custom(Map<String, Object> properties, final Result result) {
    try {
      String event = null;
      Map<String, Object> props = null;
      if (properties.containsKey("event")) {
        event = (String) properties.get("event");
      }
      if (properties.containsKey(KEY_PROPERTIES)) {
        props = (Map<String, Object>) properties.get(KEY_PROPERTIES);
      }
      if (event != null) {
        GainsightPX.with(context).custom(event, props, new GainsightPX.ExceptionHandler() {
          public void onExceptionOccurred(String methodName, ValueMap params, String exceptionMessage) {
            result.error(methodName, exceptionMessage, params);
          }
        });
        result.success("custom");
      } else {
        result.error(ERROR_CODE, "Event name must not be null", properties);
      }
    } catch (Throwable tr) {
      result.error(ERROR_CODE, tr.getMessage(), tr);
      Log.e(TAG, "custom: ", tr);
    }
  }

  @SuppressWarnings("unchecked")
  private void screen(Map<String, Object> properties, final Result result) {
    try {
      String screenName = null;
      String screenClass = null;
      Map<String, Object> props = null;
      if (properties.containsKey("screenName")) {
        screenName = (String) properties.get("screenName");
      }
      if (properties.containsKey("screenClass")) {
        screenClass = (String) properties.get("screenClass");
      }
      if (properties.containsKey(KEY_PROPERTIES)) {
        props = (Map<String, Object>) properties.get(KEY_PROPERTIES);
      }
      if (screenName != null) {
        ScreenEventData screenEventData = new ScreenEventData(screenName);
        if (screenClass != null) {
          screenEventData.putScreenClass(screenClass);
        }
        if (props != null) {
          screenEventData.putProperties(props);
        }
        GainsightPX.with(context).screen(screenEventData, new GainsightPX.ExceptionHandler() {
          public void onExceptionOccurred(String methodName, ValueMap params, String exceptionMessage) {
            result.error(methodName, exceptionMessage, params);
          }
        });
        result.success("screen");
      } else {
        result.error(ERROR_CODE, "Screen name must not be null", properties);
      }
    } catch (Throwable tr) {
      result.error(ERROR_CODE, tr.getMessage(), tr);
      Log.e(TAG, "screen: ", tr);
    }
  }

  private void enableDisable(boolean value, final Result result) {
    try {
      GainsightPX.with(context).setEnable(value);
      result.success(value ? "enabled" : "disabled");
    } catch (Throwable e) {
      result.error(ERROR_CODE, e.getMessage(), e);
      Log.e(TAG, value ? "enable: " : "disable: ", e);
    }
  }

  private void flush(final Result result) {
    try {
      GainsightPX.with(context).flush(new GainsightPX.ExceptionHandler() {
        public void onExceptionOccurred(String methodName, ValueMap params, String exceptionMessage) {
          result.error(methodName, exceptionMessage, params);
        }
      });
      result.success("flush");
    } catch (Throwable e) {
      result.error(ERROR_CODE, e.getMessage(), e);
      Log.e(TAG, "flush: ", e);
    }
  }

  private void reset(final Result result) {
    try {
      GainsightPX.with(context).reset();
      result.success("reset");
    } catch (Throwable e) {
      result.error(ERROR_CODE, e.getMessage(), e);
      Log.e(TAG, "reset: ", e);
    }
  }

  private void hardReset(final Result result) {
    try {
      GainsightPX.with().shutdown();
      result.success("hardReset");
    } catch (Throwable e) {
      result.error(ERROR_CODE, e.getMessage(), e);
      Log.e(TAG, "hardReset: ", e);
    }
  }

  @SuppressWarnings("unchecked")
  private void enableEngagements(Map<String, Object> properties, final Result result) {
    try {
      if (properties.containsKey("enable")) {
        Object object = properties.get("enable");
        if (object instanceof Boolean) {
          boolean enableEngagements = (Boolean) object;
          GainsightPX.with().enableEngagements(enableEngagements);
          result.success("enableEngagements");
          return;
        }
      }
      result.error(ERROR_CODE, "Unable to find required fields for enabling/disabling engagements", null);
    } catch (Throwable tr) {
      result.error(ERROR_CODE, tr.getMessage(), tr);
      Log.e(TAG, "screen: ", tr);
    }
  }

  @SuppressWarnings("unchecked")
  private void removeGlobalContextKeys(Map<String, Object> properties, final Result result) {
    try {
      List<String> keys = null;
      if (properties.containsKey("keys")) {
        keys = (List<String>) properties.get("keys");
      }
      if (keys != null) {
        GlobalContextData globalContextData = GainsightPX.with(context).getGlobalContext();
        if (globalContextData != null) {
          for (int i = 0; i < keys.size(); i++) {
            globalContextData.removeKey(keys.get(i));
          }
        }
      }
      result.success("removed");
    } catch (Throwable tr) {
      Log.e(TAG, "globalContext: ", tr);
      result.error(ERROR_CODE, tr.getMessage(), tr);
    }
  }

  @SuppressWarnings("unchecked")
  private void setGlobalContext(Map<String, Object> properties, final Result result) {
    try {
      Map<String, Object> params = null;
      if (properties.containsKey("params")) {
        params = (Map<String, Object>) properties.get("params");
      }
      if (params != null) {
        GlobalContextData globalContextData;
        if (GainsightPX.with(context).getGlobalContext() != null) {
          globalContextData = GainsightPX.with(context).getGlobalContext();
        } else {
          globalContextData = new GlobalContextData();
          GainsightPX.with(context).setGlobalContext(globalContextData);
        }
        for (Map.Entry<String, Object> entry : params.entrySet()) {
          if (entry.getValue() instanceof String) {
            globalContextData.putString(entry.getKey(), (String) entry.getValue());
          } else if (entry.getValue() instanceof Long) {
            globalContextData.putNumber(entry.getKey(), (Long) entry.getValue());
          } else if (entry.getValue() instanceof Integer) {
            globalContextData.putNumber(entry.getKey(), (Integer) entry.getValue());
          } else if (entry.getValue() instanceof Double) {
            globalContextData.putNumber(entry.getKey(), (Double) entry.getValue());
          } else if (entry.getValue() instanceof Boolean) {
            globalContextData.putBoolean(entry.getKey(), (Boolean) entry.getValue());
          }
        }
      } else {
        GainsightPX.with(context).setGlobalContext(null);
      }
      result.success("globalContext");
    } catch (Throwable tr) {
      result.error(ERROR_CODE, tr.getMessage(), tr);
      Log.e(TAG, "globalContext: ", tr);
    }
  }

  private void hasGlobalContextKey(Map<String, Object> properties, final Result result) {
    try {
      String key = null;
      if (properties.containsKey("key")) {
        key = (String) properties.get("key");
      }
      boolean value = false;
      if ((key != null) && (GainsightPX.with(context).getGlobalContext() != null)) {
        value = GainsightPX.with(context).getGlobalContext().hasKey(key);
      }
      result.success(value);
    } catch (Throwable tr) {
      Log.e(TAG, "globalContext: ", tr);
      result.error(ERROR_CODE, tr.getMessage(), tr);
    }
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
    if (this.activity instanceof FlutterActivity) {
      if (((FlutterActivity) this.activity).getRenderMode() == RenderMode.surface) {
        this.renderViewClass = FlutterSurfaceView.class.getName();
      } else {
        this.renderViewClass = FlutterTextureView.class.getName();
      }
    }
    if (null == mainHandler) {
      mainHandler = new Handler(activity.getMainLooper());
    }
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
    mainHandler = null;
  }

  private void reportTap(Map<String, Object> properties, final Result result) {
    try {
      if (null != tapListener) {
        String tappedView = (String) properties.get("tappedView");
        List<?> viewElements = null;
        if (properties.get("viewElements") instanceof List) {
          viewElements = (List<?>) properties.get("viewElements");
        }
        int points = (int) properties.get("points");
        @SuppressWarnings("unchecked")
        Map<String, Object> rect = (Map<String, Object>) properties.get("rect");
        tapListener.onInteractionHappened(UIDelegate.InteractionReport.TAP, new FlutterTreeBuilder(tappedView, viewElements, rect), points);
        result.success("tapReported");
      } else {
        result.error("failure", "listener not set", null);
      }
    } catch (Throwable tr) {
      result.error("failure", "Something failed", tr);
    }
  }

  private void enterEditing(Map<String, Object> properties, final Result result) {
    try {
      String editorUrl = (String) properties.get("url");
      Uri uri = Uri.parse(editorUrl);
      Intent intent = new Intent();
      intent.setData(uri);
      GainsightPX.with(context).enterEditingMode(intent);
      result.success("editorOpened");
    } catch (Throwable tr) {
      result.error("failure", "Something failed", tr);
    }
  }

  private void exitEditing(final Result result) {
    try {
      GainsightPX.with(context).exitEditingMode();
      result.success("editorClosed");
    } catch (Throwable tr) {
      result.error("failure", "Something failed", tr);
    }
  }

  private static class FlutterTreeBuilder implements UIDelegate.TreeBuilder {
    private final String tappedView;
    private final List list;
    private final Map<String, Object> rect;
    private Rect frame = null;

    public FlutterTreeBuilder(String view, List viewElements, Map<String, Object> rect) {
      this.tappedView = view;
      this.list = viewElements;
      this.rect = rect;
    }

    @Override
    public List<ValueMap> build() {
      List<ValueMap> tree = new ArrayList<>();
      if (null != this.list) {
        for (Object object : this.list) {
          if (object instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> map = (Map<String, Object>) object;
            tree.add(new ValueMap(map));
          }
        }
      }
      return tree;
    }

    @Override
    public String getTopViewClass() {
      return this.tappedView;
    }

    @Override
    public Rect getFrame() {
      if ((null == frame) && (null != this.rect)) {
        int x = getAsInt(this.rect.get("x"));
        int y = getAsInt(this.rect.get("y"));
        this.frame = new Rect(x, y, x + getAsInt(this.rect.get("width")), y + getAsInt(this.rect.get("height")));
      }
      return frame;
    }

    static int getAsInt(Object object) {
      if (object instanceof Integer) {
        return (Integer) object;
      } else if (object instanceof Double) {
        return ((Double)object).intValue();
      }
      return -1;
    }
  }

  private class SafeResult implements Result {
    private final Result result;
    private boolean answered;

    SafeResult(Result original) {
      this.result = original;
      this.answered = false;
    }
    @Override
    public void success(@Nullable Object result) {
      if ((null != result) && !answered) {
        this.result.success(result);
        this.answered = true;
      }
    }

    @Override
    public void error(String errorCode, @Nullable final String errorMessage, @Nullable Object errorDetails) {
      if ((null != result) && !answered) {
        this.result.error(errorCode, errorMessage, errorDetails);
        this.answered = true;
      }
    }

    @Override
    public void notImplemented() {
      if ((null != result) && !answered) {
        this.result.notImplemented();
        this.answered = true;
      }
    }
  }
}