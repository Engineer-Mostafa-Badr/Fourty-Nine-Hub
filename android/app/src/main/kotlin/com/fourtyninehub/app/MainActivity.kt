package com.fourtyninehub.app

import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.PowerManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.fourtyninehub.app/background_service"
    private var wakeLock: PowerManager.WakeLock? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "acquireWakeLock" -> {
                    acquireWakeLock()
                    result.success(true)
                }
                "releaseWakeLock" -> {
                    releaseWakeLock()
                    result.success(true)
                }
                "startBackgroundService" -> {
                    val roomId = call.argument<String>("roomId") ?: ""
                    val userId = call.argument<String>("userId") ?: ""
                    val isVideoCall = call.argument<Boolean>("isVideoCall") ?: false
                    startBackgroundService(roomId, userId, isVideoCall)
                    result.success(true)
                }
                "keepServiceAlive" -> {
                    keepServiceAlive()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun acquireWakeLock() {
        if (wakeLock == null) {
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            wakeLock = powerManager.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
                "FourtyNineHub:CallWakeLock"
            )
            wakeLock?.setReferenceCounted(false)
        }
        
        if (wakeLock?.isHeld == false) {
            wakeLock?.acquire(10*60*1000L) // 10 minutes timeout
        }
    }

    private fun releaseWakeLock() {
        if (wakeLock?.isHeld == true) {
            wakeLock?.release()
        }
    }

    private fun startBackgroundService(roomId: String, userId: String, isVideoCall: Boolean) {
        val serviceIntent = Intent(this, CallBackgroundService::class.java).apply {
            putExtra("roomId", roomId)
            putExtra("userId", userId)
            putExtra("isVideoCall", isVideoCall)
        }
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }
        
        acquireWakeLock()
    }

    private fun keepServiceAlive() {
        // Refresh wake lock
        if (wakeLock?.isHeld == true) {
            wakeLock?.release()
        }
        acquireWakeLock()
    }

    override fun onDestroy() {
        releaseWakeLock()
        super.onDestroy()
    }
}
