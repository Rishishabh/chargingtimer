package com.example.chargingtimer

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Bundle
import android.os.SystemClock
import android.widget.Chronometer
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    private lateinit var chronometer: Chronometer
    private lateinit var statusText: TextView
    private lateinit var startPercentText: TextView
    private lateinit var endPercentText: TextView

    private var isCharging = false
    private var startPercentage: Int = -1
    private var endPercentage: Int = -1

    private val batteryReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val status = intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
            val charging = status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL
            val level = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1

            if (charging && !isCharging) {
                isCharging = true
                startPercentage = level
                statusText.text = "Charging..."
                startPercentText.text = "Start: $startPercentage%"
                chronometer.base = SystemClock.elapsedRealtime()
                chronometer.start()

            } else if (!charging && isCharging) {
                isCharging = false
                endPercentage = level
                statusText.text = "Unplugged"
                endPercentText.text = "End: $endPercentage%"
                chronometer.stop()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        chronometer = findViewById(R.id.chronometer)
        statusText = findViewById(R.id.statusText)
        startPercentText = findViewById(R.id.startPercentText)
        endPercentText = findViewById(R.id.endPercentText)

        registerReceiver(
            batteryReceiver,
            IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        )
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(batteryReceiver)
    }
}