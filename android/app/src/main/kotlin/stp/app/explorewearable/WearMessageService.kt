package stp.app.explorewearable

import android.content.Intent
import android.util.Log
import com.google.android.gms.wearable.*

class WearMessageService : WearableListenerService() {
    override fun onMessageReceived(messageEvent: MessageEvent) {
        Log.d("PHONE_APP", "onMessageReceived path: ${messageEvent.path}")
        if (messageEvent.path == "/next_step") {
            val dataString = String(messageEvent.data)
            Log.d("PHONE_APP", "Message content: $dataString")

            val intent = Intent("NEXT_STEP_EVENT")
            intent.setPackage(packageName) // Ensure only this app receives the broadcast
            intent.putExtra("data", dataString)
            sendBroadcast(intent)
        }
    }
}