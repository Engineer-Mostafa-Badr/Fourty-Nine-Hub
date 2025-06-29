package com.fourtyninehub.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat

class CallBackgroundService : Service() {
    private var wakeLock: PowerManager.WakeLock? = null
    private val NOTIFICATION_ID = 10001
    private val CHANNEL_ID = "call_service_channel"

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        acquireWakeLock()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val roomId = intent?.getStringExtra("roomId") ?: ""
        val userId = intent?.getStringExtra("userId") ?: ""
        val isVideoCall = intent?.getBooleanExtra("isVideoCall", false) ?: false
        
        val notification = createNotification(isVideoCall)
        startForeground(NOTIFICATION_ID, notification)
        
        return START_STICKY
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Call Background Service",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Keeps call active in the background"
                setSound(null, null)
            }
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(isVideoCall: Boolean) = NotificationCompat.Builder(this, CHANNEL_ID)
        .setContentTitle("Ongoing Call")
        .setContentText(if (isVideoCall) "Video call in progress" else "Voice call in progress")
        //.setSmallIcon(R.drawable.ic_notification)  // You need to add this icon resource
        .setPriority(NotificationCompat.PRIORITY_HIGH)
        .setOngoing(true)
        .setContentIntent(createPendingIntent())
        .build()

    private fun createPendingIntent(): PendingIntent {
        val intent = packageManager.getLaunchIntentForPackage(packageName)
        return PendingIntent.getActivity(
            this, 0, intent,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
        )
    }

    private fun acquireWakeLock() {
        if (wakeLock == null) {
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            wakeLock = powerManager.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "FourtyNineHub:CallServiceWakeLock"
            )
            wakeLock?.setReferenceCounted(false)
        }
        
        if (wakeLock?.isHeld == false) {
            wakeLock?.acquire(30*60*1000L)  // 30 minutes timeout
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        if (wakeLock?.isHeld == true) {
            wakeLock?.release()
        }
        super.onDestroy()
    }
}
