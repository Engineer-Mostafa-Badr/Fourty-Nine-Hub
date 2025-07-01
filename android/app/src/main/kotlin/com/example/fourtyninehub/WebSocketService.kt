package com.fourtyninehub.fourtynine

import android.app.*
import android.content.Intent
import android.os.IBinder
import android.util.Log
import io.socket.client.IO
import io.socket.client.Socket
import io.socket.emitter.Emitter
import java.net.URISyntaxException

class WebSocketService : Service() {
    //private lateinit var socket: Socket
   // private var authToken: String? = null

    // Socket.IO URL (update this based on your server configuration)
   // private val socketUrl = "https://1220-41-239-172-48.ngrok-free.app" // Secure Socket.IO (HTTPS)

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
      //  val newToken = intent?.getStringExtra("TOKEN")
      //  if (newToken != null) {
      //      updateToken(newToken)
       // }
      //  return START_STICKY
      return 0
    }

    override fun onCreate() {
        super.onCreate()
        // Start Socket.IO connection and maintain it
        //startSocketConnection()

        // Start Foreground Service with a notification
        //val notification = createNotification("Socket.IO Service is running")
        //startForeground(1, notification)
    }

    private fun startSocketConnection() {
       // try {
         //   val options = IO.Options()
            //options.query = "token=$authToken" // Add the token in the query parameters

          //  socket = IO.socket(socketUrl, options)
          //  socket.connect()

          //  socket.on(Socket.EVENT_CONNECT, Emitter.Listener {
          //      Log.d("Socket.IO", "Socket.IO Connected")
          //  })
          //  socket.on(Socket.EVENT_DISCONNECT, Emitter.Listener {
          //      Log.d("Socket.IO", "Socket.IO Disconnected")
           // })
           // socket.on("user:message", Emitter.Listener { args ->
           //     val message = args[0] as String
           //     Log.d("Socket.IO", "Message received: $message")
           //     saveMessageToLocalDatabase(message)

                // Send delivery acknowledgment back to the server
           //     socket.emit("Message:Delivered", "Message delivered: $message")
           // })
           // socket.on("error", Emitter.Listener { args ->
           //     val message = args[0] as String
           //     Log.e("Socket.IO", "Error: $message")

            //})
           // socket.on(Socket.EVENT_CONNECT_ERROR, Emitter.Listener { args ->
           //     val error = args[0] as Throwable
           //     Log.e("Socket.IO", "Socket.IO Error: ${error.message}")
                // Handle reconnect logic here if needed
            //})

        //} catch (e: URISyntaxException) {
        //    e.printStackTrace()
        //}
    }

    private fun saveMessageToLocalDatabase(message: String) {
        // Here, save the incoming message to local storage (Room/SQLite)
        //Log.d("WebSocketService", "Saving message: $message")
        // Example: RoomDatabase.saveMessage(message)
    }

    private fun updateToken(newToken: String) {
        //Log.d("Socket.IO", "Updating token: $newToken")
        //authToken = newToken
        //socket.disconnect() // Disconnect the existing Socket.IO connection
       // startSocketConnection() // Start a new Socket.IO connection with the new token
    }

    private fun createNotification(contentText: String): Notification {
       // val notificationChannelId = "socket_service_channel"

       // if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
        //    val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
         //   val channel = NotificationChannel(
         //       notificationChannelId,
          //      "Socket.IO Service",
          //      NotificationManager.IMPORTANCE_LOW
          //  )
          //  notificationManager.createNotificationChannel(channel)
      //  }

       // val notificationIntent = Intent(this, MainActivity::class.java)
       // val pendingIntent = PendingIntent.getActivity(
        //    this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE
        //)

       // return Notification.Builder(this, notificationChannelId)
        //    .setContentTitle("Socket.IO Service")
        //    .setContentText(contentText)
        //    .setSmallIcon(R.drawable.ic_launcher)
        //    .setContentIntent(pendingIntent)
        //    .setTicker("Socket.IO Service Running")
        //    .build()
        return Notification()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        //socket.disconnect()
        Log.d("WebSocketService", "Service Destroyed")
    }
}
