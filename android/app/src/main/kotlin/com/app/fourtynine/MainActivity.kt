package com.app.fourtynine

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import android.os.Bundle
import im.zego.zego_express_engine.ZegoExpressEnginePlugin

class MainActivity: FlutterActivity() {
    private var deepArPlugin: Any? = null
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Let Flutter handle plugin registration properly
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        
        // Register custom plugins safely
        flutterEngine.plugins.add(ScreenWakeLockPlugin())
      }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }
    
    override fun onDestroy() {
        // Safely cleanup ZegoExpressEngine before destruction
        
        try {
            super.onDestroy()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}