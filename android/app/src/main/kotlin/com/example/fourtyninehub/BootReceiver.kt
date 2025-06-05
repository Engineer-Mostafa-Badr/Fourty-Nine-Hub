package com.fourtyninehub.fourtynine

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
       // if (intent?.action == Intent.ACTION_BOOT_COMPLETED) {
            // Start the WebSocketService when the device is rebooted
            //val serviceIntent = Intent(context, WebSocketService::class.java)
            //context.startForegroundService(serviceIntent)
       // }
    }
}
