package com.flushare

import android.net.wifi.p2p.WifiP2pManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    private val CHANNEL = "com.flushare/wifi"

    private lateinit var wifiP2pManager: WifiP2pManager
    private lateinit var channel: WifiP2pManager.Channel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        wifiP2pManager = getSystemService(WIFI_P2P_SERVICE) as WifiP2pManager
        channel = wifiP2pManager.initialize(this, mainLooper, null)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startWifiDirect" -> startWifiDirectDiscovery(result)
                "connectToPeer" -> {
                    val address = call.argument<String>("address")
                    connectToPeer(address, result)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startWifiDirectDiscovery(result: MethodChannel.Result) {
        wifiP2pManager.discoverPeers(channel, object : WifiP2pManager.ActionListener {
            override fun onSuccess() {
                result.success("Discovery started")
            }

            override fun onFailure(reason: Int) {
                result.error("ERROR", "Discovery failed with reason $reason", null)
            }
        })
    }

    private fun connectToPeer(address: String?, result: MethodChannel.Result) {
        // Here you would implement code to connect to the peer using the provided address.
        // This part is more involved and would typically require creating a WifiP2pConfig object.
        result.success("Connected to peer at $address")
    }
}
