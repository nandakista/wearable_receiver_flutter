package stp.app.explorewearable

import android.content.Context
import android.util.Log
import com.google.android.gms.wearable.Wearable

object WearableMessageService {

    private const val TAG = "WearableMessageService"

    fun sendMessage(
        context: Context,
        path: String,
        message: String
    ) {
        Wearable.getNodeClient(context).connectedNodes
            .addOnSuccessListener { nodes ->

                if (nodes.isEmpty()) {
                    Log.e(TAG, "No connected wear devices")
                    return@addOnSuccessListener
                }

                for (node in nodes) {
                    Log.d(TAG, "Sending to node: ${node.displayName}")

                    Wearable.getMessageClient(context)
                        .sendMessage(node.id, path, message.toByteArray())
                        .addOnSuccessListener {
                            Log.d(TAG, "Message sent success")
                        }
                        .addOnFailureListener {
                            Log.e(TAG, "Message failed: ${it.message}")
                        }
                }
            }
            .addOnFailureListener {
                Log.e(TAG, "Node fetch failed: ${it.message}")
            }
    }
}