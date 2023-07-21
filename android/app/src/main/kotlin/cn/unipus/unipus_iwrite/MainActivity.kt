package cn.unipus.iwrite

import android.os.Bundle
import cn.unipus.unipus_iwrite.apm.DataRangerManager
import io.flutter.embedding.android.FlutterActivity
import com.bytedance.applog.AppLog
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import org.json.JSONException
import org.json.JSONObject
import java.lang.IllegalArgumentException


class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        try {
//            params.put("title", "the video title here")
//        } catch (e: JSONException) {
//            print("MainActivity  $e")
//        }
//        AppLog.onEventV3("play_video", params)

//        throw IllegalArgumentException("测试 apm ，崩溃")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        //实例化 //flutter 调用原生'Channel'
        DataRangerManager(flutterEngine = flutterEngine.dartExecutor.binaryMessenger,context = baseContext)
    }
}
