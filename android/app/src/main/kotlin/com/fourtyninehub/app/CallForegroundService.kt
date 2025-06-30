package com.fourtyninehub.app

import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.os.*
import android.util.Log
import androidx.core.app.NotificationCompat

class CallForegroundService : Service() {
    private val TAG: String = "CallForegroundService"
    private val NOTIFICATION_ID: Int = 1000
    private val CHANNEL_ID: String = "call_channel"
    private var wakeLock: PowerManager.WakeLock? = null
    private var audioManager: AudioManager? = null
    private var audioFocusRequest: AudioFocusRequest? = null
    private var keepAliveHandler: Handler? = null
    
    // Fix: Change to a lateinit var instead of a val with immediate initialization
    private lateinit var keepAliveRunnable: Runnable

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "CallForegroundService created")
        
        // Fix: Initialize the runnable here after declaration
        keepAliveRunnable = Runnable {
            // Log that the service is still alive
            Log.d(TAG, "Keep-alive ping to maintain service")
            keepAliveHandler?.postDelayed(keepAliveRunnable, 5000)  // Run every 5 seconds
        }
        
        // Create notification channel for Android O and above
        createNotificationChannel()
        
        // Get audio manager
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        
        // Start keep-alive mechanism
        keepAliveHandler = Handler(Looper.getMainLooper())
        keepAliveHandler?.postDelayed(keepAliveRunnable, 5000)
        
        // Acquire partial wake lock to keep CPU running
        safeAcquireWakeLock()
        
        // Request audio focus with highest priority
        requestAudioFocus()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "CallForegroundService started")
        
        // Extract call info if available
        val roomId: String = intent?.getStringExtra("roomId") ?: "unknown_room"
        val userId: String = intent?.getStringExtra("userId") ?: "unknown_user"
        val isVideoCall: Boolean = intent?.getBooleanExtra("isVideoCall", false) ?: false
        val callType: String = if (isVideoCall) "Video" else "Audio"
        
        try {
            // Update notification with call info
            val notification = createNotification("$callType call in progress")
            startForeground(NOTIFICATION_ID, notification)
            
            // Request audio focus again in case it was lost
            requestAudioFocus()
            
            // Ensure wake lock is acquired
            safeAcquireWakeLock()
        } catch (e: Exception) {
            Log.e(TAG, "Error in onStartCommand: ${e.message}")
        }
        
        // If service is killed, restart it
        return START_STICKY
    }

    private fun createNotification(text: String): Notification {
        // Intent to open the app when notification is tapped
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            packageManager.getLaunchIntentForPackage(packageName),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Call in Progress")
            .setContentText(text)
            .setSmallIcon(android.R.drawable.ic_menu_call)
            .setContentIntent(pendingIntent)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setOngoing(true)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Call Service Channel",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Used for ongoing calls"
                enableLights(true)
                lightColor = Color.RED
                setShowBadge(true)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                importance = NotificationManager.IMPORTANCE_HIGH
            }
            
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }

    private fun safeAcquireWakeLock() {
        try {
            if (wakeLock == null) {
                val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
                wakeLock = powerManager.newWakeLock(
                    PowerManager.PARTIAL_WAKE_LOCK,
                    "CallForegroundService::CallWakeLock"
                )
                wakeLock?.setReferenceCounted(false)
                wakeLock?.acquire(10*60*1000L /*10 minutes*/)
                Log.d(TAG, "Wake lock acquired")
            } else if (!(wakeLock?.isHeld ?: false)) {
                wakeLock?.acquire(10*60*1000L /*10 minutes*/)
                Log.d(TAG, "Wake lock re-acquired")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error acquiring wakelock: ${e.message}")
        }
    }
    
    fun requestAudioFocus() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_VOICE_COMMUNICATION)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                    .build()
                    
                audioFocusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
                    .setAudioAttributes(audioAttributes)
                    .setAcceptsDelayedFocusGain(false)
                    .setWillPauseWhenDucked(false)
                    .setOnAudioFocusChangeListener { }
                    .build()
                    
                audioManager?.requestAudioFocus(audioFocusRequest!!)
            } else {
                audioManager?.requestAudioFocus(
                    null,
                    AudioManager.STREAM_VOICE_CALL,
                    AudioManager.AUDIOFOCUS_GAIN
                )
            }
            
            // Force call mode
            audioManager?.mode = AudioManager.MODE_IN_COMMUNICATION
            Log.d(TAG, "Audio focus requested")
        } catch (e: Exception) {
            Log.e(TAG, "Error requesting audio focus: ${e.message}")
        }
    }

    override fun onDestroy() {
        Log.d(TAG, "CallForegroundService destroyed")
        
        try {
            // Release wake lock
            wakeLock?.let {
                if (it.isHeld) {
                    it.release()
                }
            }
            wakeLock = null
            
            // Abandon audio focus
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                audioFocusRequest?.let { audioManager?.abandonAudioFocusRequest(it) }
            } else {
                audioManager?.abandonAudioFocus(null)
            }
            
            // Stop keep-alive handler
            keepAliveHandler?.removeCallbacks(keepAliveRunnable)
        } catch (e: Exception) {
            Log.e(TAG, "Error in onDestroy: ${e.message}")
        }
        
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
