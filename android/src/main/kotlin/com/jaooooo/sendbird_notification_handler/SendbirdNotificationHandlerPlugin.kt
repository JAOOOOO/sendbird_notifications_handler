package com.jaooooo.sendbird_notification_handler

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Build.VERSION
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.NewIntentListener
import org.json.JSONObject

/** SendbirdNotificationHandlerPlugin */
class SendbirdNotificationHandlerPlugin: FlutterPlugin,
  MethodCallHandler,
  EventChannel.StreamHandler,
  NewIntentListener,
  ActivityAware {

  companion object {
    const val SHOW_NOTIFICATION = "showNotification"
    const val GET_INITIAL_MESSAGE = "getInitialMessage"
    const val CHANNEL_ID = "sendbird_notification_handler_channel"
    const val CHANNEL_NAME = "sendbird_notification_handler_channel"
    const val PAYLOAD_KEY = "bird_message"
    const val TAG = "SendbirdHandler"
    const val MESSAGE_OPENED_APP_KEY = "active"
  }

  private lateinit var channel : MethodChannel
  private lateinit var applicationContext: Context
  private lateinit var eventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null
  private var birdMessage: BirdMessage? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sendbird_notification_handler")
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "sendbird_notification_handler_events")
    eventChannel.setStreamHandler(this)
    channel.setMethodCallHandler(this)

    applicationContext = flutterPluginBinding.applicationContext
    createNotificationChannel()
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      SHOW_NOTIFICATION -> {
        val payload = call.argument<HashMap<*, *>>("payload") ?: throw IllegalArgumentException("payload is required")
        val title = call.argument<String?>("title")
        val body = call.argument<String?>("body")
        val payloadJson = JSONObject(payload)
        showNotification(title, body, payloadJson)
        result.success(null)
      }
      GET_INITIAL_MESSAGE -> {
        result.success(getInitialMessage())
      }
      else -> {
        result.notImplemented()
      }
    }
  }




  private fun showNotification(title: String?, body: String?, payload: JSONObject) {
    Log.d(TAG,"SHOW NOTIFICATION CALLED")
    val info = applicationContext.packageManager.getApplicationInfo(applicationContext.packageName, 0)
    val pendingIntent = getPendingIntent(payload)

    val messageId= JSONObject(payload.getString("sendbird")).getLong("message_id")


    val notification = NotificationCompat.Builder(applicationContext, CHANNEL_ID)
      .setContentTitle(createTitle(title, payload))
      .setContentText(createContentText(body, payload))
      .setContentIntent(pendingIntent)
      .setSmallIcon(info.icon)
      .setAutoCancel(true)
      .setPriority(NotificationCompat.PRIORITY_DEFAULT)
      .build()

    with(NotificationManagerCompat.from(applicationContext)) {
      notify(messageId.toInt(), notification)
    }
  }

  private fun createNotificationChannel() {
    // Create the NotificationChannel, but only on API 26+ because
    // the NotificationChannel class is new and not in the support library
    if (VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      val descriptionText = "Sendbird Notification Handler"
      val importance = NotificationManager.IMPORTANCE_DEFAULT
      val channel = NotificationChannel(CHANNEL_ID, CHANNEL_NAME, importance).apply {
        description = descriptionText
      }
      // Register the channel with the system
      val notificationManager: NotificationManager =
        applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
      notificationManager.createNotificationChannel(channel)
    }
  }

  private fun getInitialMessage() : String? {
    val message = birdMessage?.toJson()?.toString()
    birdMessage= null
    return  message
  }

  private fun getPendingIntent(payload: JSONObject): PendingIntent? {
    val intent = applicationContext.packageManager.getLaunchIntentForPackage(applicationContext.packageName)
    intent?.action = Intent.ACTION_MAIN
    intent?.putExtra(PAYLOAD_KEY, payload.getString("sendbird"))
    var flags = PendingIntent.FLAG_UPDATE_CURRENT
    if (VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      flags = flags or PendingIntent.FLAG_IMMUTABLE
    }
    return PendingIntent.getActivity(applicationContext, 0, intent, flags)
  }

  private fun createTitle(title: String?, payload: JSONObject): String {
    return title ?:( payload["sendbird"] as String).let {
        val sendbird = JSONObject(it)
      val sender = sendbird["sender"] as JSONObject
        val senderName = sender["name"] as String
      "$senderName sent you a message"
    }

  }

  private fun createContentText(body: String?, payload: JSONObject): String {
    return body ?:( payload["sendbird"] as String).let {
        val sendbird = JSONObject(it)
       sendbird["message"] as String

    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {

  }

  override fun onNewIntent(intent: Intent): Boolean {
    val hasBirdMessage = intent.hasExtra(PAYLOAD_KEY)
    Log.d(TAG,"hasBirdMessage: $hasBirdMessage")

    if (!hasBirdMessage) {
      return false
    }

    val payload = intent.getStringExtra(PAYLOAD_KEY)
    val payloadJson = JSONObject(payload!!)
    val birdMessage = BirdMessage.fromJson(payloadJson)
    if (eventSink == null) {
      return false
    }
    val jsonObject = JSONObject()
    jsonObject.put(MESSAGE_OPENED_APP_KEY, birdMessage.toJson())
    val jsonString = jsonObject.toString()
    eventSink?.success(jsonString)
    return true
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    binding.addOnNewIntentListener(this)
    val intent = binding.activity.intent
    val launchedFromHistory = intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY == Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY
    val hasMessage = intent.hasExtra(PAYLOAD_KEY)
    if (launchedFromHistory || !hasMessage)
      return

    val messagePayload = JSONObject(intent.getStringExtra(PAYLOAD_KEY)!!)
    birdMessage = BirdMessage.fromJson(messagePayload)


  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    Log.d(TAG,"onReattachedToActivityForConfigChanges")
    binding.addOnNewIntentListener(this)

  }

  override fun onDetachedFromActivity() {
    Log.d(TAG,"onDetachedFromActivity")
  }
}
