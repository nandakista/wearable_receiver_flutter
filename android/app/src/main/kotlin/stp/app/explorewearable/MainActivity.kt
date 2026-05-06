package stp.app.explorewearable

import android.content.*
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "watch_channel"
    private var receiver: BroadcastReceiver? = null
    private var methodChannel: MethodChannel? = null

    private var connectionMonitor: WearableConnectionMonitor? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )

        methodChannel?.setMethodCallHandler { call, result ->
            if (call.method == "sendToWatch") {
                val message = call.argument<String>("message") ?: ""
                val path = call.argument<String>("path") ?: "/notify"
                WearableMessageService.sendMessage(this, path, message)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        connectionMonitor = WearableConnectionMonitor(this) { devices ->
            methodChannel?.invokeMethod("connectionStatus", devices)
        }
        connectionMonitor?.start()

        receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == "NEXT_STEP_EVENT") {
                    val data = intent.getStringExtra("data")

                    Log.d("PHONE_APP", "Event received from watch: $data")

                    methodChannel?.invokeMethod("onNext", data)
                }
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(
                receiver,
                IntentFilter("NEXT_STEP_EVENT"),
                Context.RECEIVER_NOT_EXPORTED
            )
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            registerReceiver(
                receiver,
                IntentFilter("NEXT_STEP_EVENT")
            )
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        receiver?.let {
            unregisterReceiver(it)
        }
        connectionMonitor?.stop()
    }
}