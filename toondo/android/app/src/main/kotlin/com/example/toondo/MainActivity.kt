package com.example.toondo

import android.os.Bundle
import android.os.Process
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
	private var cachedEngine: FlutterEngine? = null

	override fun onCreate(savedInstanceState: Bundle?) {
		Log.i(TAG, "onCreate() pid=${Process.myPid()} tid=${Process.myTid()}")
		startStartupWatchdog()
		super.onCreate(savedInstanceState)
		Log.i(TAG, "onCreate() finished")
	}

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		Log.i(TAG, "configureFlutterEngine() begin")
		try {
			cachedEngine = flutterEngine
			super.configureFlutterEngine(flutterEngine)
			Log.i(TAG, "configureFlutterEngine() end")
		} catch (t: Throwable) {
			Log.e(TAG, "configureFlutterEngine() crashed", t)
			throw t
		}
	}

	private fun startStartupWatchdog() {
		Thread {
			try {
				// 스플래시 고정이 재현되면 여기 로그가 찍히며, 당시 전체 스레드 스택이 출력됩니다.
				Thread.sleep(15_000)
				val executingDart = try {
					cachedEngine?.dartExecutor?.isExecutingDart
				} catch (_: Throwable) {
					null
				}
				Log.e(TAG, "WATCHDOG: isExecutingDart=$executingDart")
				Log.e(TAG, "WATCHDOG: still starting after 15s. Dumping thread stacks...")
				dumpAllThreadStacks()
			} catch (t: Throwable) {
				Log.e(TAG, "WATCHDOG failed", t)
			}
		}.apply {
			name = "startup-watchdog"
			isDaemon = true
			start()
		}
	}

	private fun dumpAllThreadStacks() {
		val stacks = Thread.getAllStackTraces()
		for ((thread, stack) in stacks) {
			Log.e(TAG, "--- Thread: ${thread.name} state=${thread.state} ---")
			for (el in stack) {
				Log.e(TAG, "    at $el")
			}
		}
	}

	private companion object {
		private const val TAG = "ToonDoBoot"
	}
}
