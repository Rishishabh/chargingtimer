package com.example.chargingtimer.utils

import android.content.Context
import android.util.Log
import java.io.File
import java.io.FileWriter
import java.io.IOException

object AppLogger {
    fun log(context: Context, tag: String, message: String) {
        Log.d(tag, message) // Also log to Logcat

        try {
            val logFile = File(context.getExternalFilesDir(null), "log.txt")
            val writer = FileWriter(logFile, true)
            writer.append("${System.currentTimeMillis()} | $tag: $message\n")
            writer.flush()
            writer.close()
        } catch (e: IOException) {
            Log.e("AppLogger", "Error writing log file", e)
        }
    }
}
