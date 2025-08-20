package com.fourtyninehub.fourtyninehub

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat

class BackgroundAudioService : Service() {
    private var wakeLock: PowerManager.WakeLock? = null
    
    override fun onCreate() {
        super.onCreate()
        
        // Create a notification channel for foreground service
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "ongoing_call_channel",
                "Ongoing Call",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Used to maintain call audio in the background"
                setSound(null, null)
            }
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
        
        // Create and show notification
        val notification = createNotification()
        
        // Start as foreground service with FOREGROUND_SERVICE_TYPE_MICROPHONE
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(NOTIFICATION_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE)
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
        
        // Acquire wake lock to keep CPU running
        acquireWakeLock()
    }
    
    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, "ongoing_call_channel")
            .setContentTitle("Ongoing Call")
            .setContentText("Call in progress. Tap to return.")
            //.setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setOngoing(true)
            .build()
    }
    
    private fun acquireWakeLock() {
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "FourtyNineHub:CallWakeLock"
        )
        wakeLock?.acquire(1000 * 60 * 60 * 3) // 3 hours timeout
    }
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Make service sticky - if system kills it, it will be restarted
        return START_STICKY
    }
    
    override fun onDestroy() {
        wakeLock?.let {
            if (it.isHeld) {
                it.release()
            }
        }
        super.onDestroy()
    }
    
    override fun onBind(intent: Intent?): IBinder? = null
    
    companion object {
        private const val NOTIFICATION_ID = 49555
    }
}