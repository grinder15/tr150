package com.grinderapps.www.tr150

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.device.PrinterManager
import android.device.ScanManager
import androidx.annotation.NonNull
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** Tr150Plugin */
class Tr150Plugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware,
        LifecycleObserver, PrinterMethodCallHandler, ScannerMethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private var activityPluginBinding: ActivityPluginBinding? = null
    private val printerManager: PrinterManager = PrinterManager()
    private val scanManager: ScanManager = ScanManager()


    companion object {
        /// Printer method names, interface for flutter method channel
        const val openPrinterMethod = "openPrinter"
        const val closePrinterMethod = "closePrinter"
        const val setSpeedLevelPrinterMethod = "setSpeedLevel"
        const val setGrayLevelPrinterMethod = "setGrayLevel"
        const val setupPagePrinterMethod = "setupPage"
        const val clearPagePrinterMethod = "clearPage"
        const val printPagePrinterMethod = "printPage"
        const val drawLinePrinterMethod = "drawLine"
        const val drawTextPrinterMethod = "drawText"
        const val drawTextExPrinterMethod = "drawTextEx"
        const val drawBarcodePrinterMethod = "drawBarcode"
        const val drawBitmapPrinterMethod = "drawBitmap"
        const val getStatusPrinterMethod = "getStatus"

        /// Scanner method names, interface for flutter method channel
        const val startDecodeScannerMethod = "startDecode"
        const val stopDecodeScannerMethod = "stopDecode"
        const val getStateScannerMethod = "getScannerState"
        const val openScannerMethod = "openScanner"
        const val closeScannerMethod = "closeScanner"
    }

    private val scanReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            //val barcode: ByteArray? = intent?.getByteArrayExtra(ScanManager.DECODE_DATA_TAG)
            //val barcodeLength: Int? = intent?.getIntExtra(ScanManager.BARCODE_LENGTH_TAG, 0)
            //val temp: Byte? = intent?.getByteExtra(ScanManager.BARCODE_TYPE_TAG, 0.toByte())
            val result: String? = intent?.getStringExtra(ScanManager.BARCODE_STRING_TAG)
            if (result != null) {
                eventSink?.success(result)
            }
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tr150")
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "tr150_event")
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            // printer methods
            openPrinterMethod -> openPrinter(call, result)
            closePrinterMethod -> closePrinter(call, result)
            setSpeedLevelPrinterMethod -> setSpeedLevel(call, result)
            setGrayLevelPrinterMethod -> setGrayLevel(call, result)
            setupPagePrinterMethod -> setupPage(call, result)
            clearPagePrinterMethod -> clearPage(call, result)
            printPagePrinterMethod -> printPage(call, result)
            drawLinePrinterMethod -> drawLine(call, result)
            drawTextPrinterMethod -> drawText(call, result)
            drawTextExPrinterMethod -> drawTextEx(call, result)
            drawBarcodePrinterMethod -> drawBarcode(call, result)
            drawBitmapPrinterMethod -> drawBitmap(call, result)
            getStatusPrinterMethod -> getStatus(call, result)
            // scanner methods
            startDecodeScannerMethod -> startDecode(call, result)
            stopDecodeScannerMethod -> stopDecode(call, result)
            getStateScannerMethod -> getScannerState(call, result)
            openScannerMethod -> openScanner(call, result)
            closeScannerMethod -> closeScanner(call, result)
            else -> result.notImplemented()
        }
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun setActivityBinding(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
        if (activityPluginBinding != null) {
            FlutterLifecycleAdapter.getActivityLifecycle(activityPluginBinding!!).addObserver(this)
        }
    }

    private fun unSetActivityBinding() {
        if (activityPluginBinding != null) {
            FlutterLifecycleAdapter.getActivityLifecycle(activityPluginBinding!!).removeObserver(this)
        }
        activityPluginBinding = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        setActivityBinding(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        unSetActivityBinding()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        setActivityBinding(binding)
    }

    override fun onDetachedFromActivity() {
        unSetActivityBinding()
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
    private fun onActivityResume() {
        val filter = IntentFilter()
        filter.addAction(ScanManager.ACTION_DECODE)
        activityPluginBinding?.activity?.registerReceiver(scanReceiver, filter)
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
    private fun onActivityPause() {
        activityPluginBinding?.activity?.unregisterReceiver(scanReceiver)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun openPrinter(call: MethodCall, result: Result) {
        result.success(printerManager.open() == 0)
    }

    override fun closePrinter(call: MethodCall, result: Result) {
        result.success(printerManager.close() == 0)
    }

    override fun setSpeedLevel(call: MethodCall, result: Result) {
        printerManager.setSpeedLevel(call.argument("level")!!)
        result.success(null)
    }

    override fun setGrayLevel(call: MethodCall, result: Result) {
        printerManager.setGrayLevel(call.argument("level")!!)
        result.success(null)
    }

    override fun setupPage(call: MethodCall, result: Result) {
        result.success(printerManager.setupPage(call.argument("width")!!,
                call.argument("height")!!) == 0)
    }

    override fun clearPage(call: MethodCall, result: Result) {
        result.success(printerManager.clearPage() == 0)
    }

    override fun printPage(call: MethodCall, result: Result) {
        result.success(printerManager.printPage(call.argument("rotate")!!))
    }

    override fun drawLine(call: MethodCall, result: Result) {
        result.success(printerManager.drawLine(call.argument("x0")!!,
                call.argument("y0")!!, call.argument("x1")!!, call.argument("y1")!!,
                call.argument("lineWidth")!!) == 0)
    }

    override fun drawText(call: MethodCall, result: Result) {
        result.success(printerManager.drawText(call.argument("data"), call.argument("x")!!,
                call.argument("y")!!, call.argument("fontName"),
                call.argument("fontSize")!!, call.argument("bold")!!,
                call.argument("italic")!!, call.argument("rotate")!!))
    }

    override fun drawTextEx(call: MethodCall, result: Result) {
        result.success(printerManager.drawTextEx(call.argument("data"), call.argument("x")!!,
                call.argument("y")!!, call.argument("width")!!,
                call.argument("height")!!, call.argument("fontName"),
                call.argument("fontSize")!!, call.argument("rotate")!!,
                call.argument("style")!!, call.argument("format")!!))
    }

    override fun drawBarcode(call: MethodCall, result: Result) {
        result.success(printerManager.drawBarcode(call.argument("data"),
                call.argument("x")!!, call.argument("y")!!, call.argument("barcodeType")!!,
                call.argument("width")!!, call.argument("height")!!,
                call.argument("rotate")!!))
    }

    override fun drawBitmap(call: MethodCall, result: Result) {
        result.success(printerManager.drawBitmapEx(call.argument("pBmp"),
                call.argument("xDest")!!, call.argument("yDest")!!,
                call.argument("widthDest")!!, call.argument("heightDest")!!))
    }

    override fun getStatus(call: MethodCall, result: Result) {
        result.success(printerManager.status)
    }

    override fun openScanner(call: MethodCall, result: Result) {
        result.success(scanManager.openScanner())
    }

    override fun closeScanner(call: MethodCall, result: Result) {
        result.success(scanManager.closeScanner())
    }

    override fun getScannerState(call: MethodCall, result: Result) {
        result.success(scanManager.scannerState)
    }

    override fun startDecode(call: MethodCall, result: Result) {
        result.success(scanManager.startDecode())
    }

    override fun stopDecode(call: MethodCall, result: Result) {
        result.success(scanManager.stopDecode())
    }
}

interface PrinterMethodCallHandler {

    fun openPrinter(call: MethodCall, result: Result)

    fun closePrinter(call: MethodCall, result: Result)

    fun setSpeedLevel(call: MethodCall, result: Result)

    fun setGrayLevel(call: MethodCall, result: Result)

    fun setupPage(call: MethodCall, result: Result)

    fun clearPage(call: MethodCall, result: Result)

    fun printPage(call: MethodCall, result: Result)

    fun drawLine(call: MethodCall, result: Result)

    fun drawText(call: MethodCall, result: Result)

    fun drawTextEx(call: MethodCall, result: Result)

    fun drawBarcode(call: MethodCall, result: Result)

    fun drawBitmap(call: MethodCall, result: Result)

    fun getStatus(call: MethodCall, result: Result)
}

interface ScannerMethodCallHandler {
    fun openScanner(call: MethodCall, result: Result)

    fun closeScanner(call: MethodCall, result: Result)

    fun getScannerState(call: MethodCall, result: Result)

    fun startDecode(call: MethodCall, result: Result)

    fun stopDecode(call: MethodCall, result: Result)
}
