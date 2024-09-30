package com.app.fourtynine

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.app.fourtynine/websocket"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startWebSocketService" -> {
                        val token = call.argument<String>("token")
                        startWebSocketService(token)
                        result.success(null)
                    }
                    "updateWebSocketToken" -> {
                        val token = call.argument<String>("token")
                        updateWebSocketToken(token)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun startWebSocketService(token: String?) {
        val intent = Intent(this, WebSocketService::class.java).apply {
            putExtra("TOKEN", token)
        }
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    private fun updateWebSocketToken(token: String?) {
        val intent = Intent(this, WebSocketService::class.java).apply {
            putExtra("TOKEN", token)
        }
        startService(intent) // Restart service to apply new token
    }
}
