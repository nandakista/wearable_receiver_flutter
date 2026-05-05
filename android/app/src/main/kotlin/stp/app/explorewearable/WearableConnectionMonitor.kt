package stp.app.explorewearable

import android.content.Context
import android.util.Log
import android.os.Handler
import android.os.Looper
import com.google.android.gms.tasks.Tasks
import com.google.android.gms.wearable.Wearable

class WearableConnectionMonitor(
  private val context: Context,
  private val onResult: (List<Map<String, Any>>) -> Unit
) {

  private val handler = Handler(Looper.getMainLooper())

  private val runnable = object : Runnable {
    override fun run() {
      Thread {
        val devices = getConnectedDevices()

        Handler(Looper.getMainLooper()).post {
          onResult(devices)
        }
      }.start()

      handler.postDelayed(this, 2000)
    }
  }

  fun start() {
    handler.post(runnable)
  }

  fun stop() {
    handler.removeCallbacks(runnable)
  }

  private fun getConnectedDevices(): List<Map<String, Any>> {
    return try {
      val nodes = Tasks.await(
        Wearable.getNodeClient(context).connectedNodes
      )
      Log.d("PHONE_APP", "Connected nodes: ${nodes.size}")
      nodes.map { node ->
        mapOf(
          "displayName" to node.displayName,
          "id" to node.id,
          "isNearby" to node.isNearby
        )
      }
    } catch (e: Exception) {
      Log.e("PHONE_APP", "Error getting connected nodes: ${e.message}")
      emptyList()
    }
  }
}