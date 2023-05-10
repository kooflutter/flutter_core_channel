package net.allinmeta.flutter_core_channel

import com.google.gson.Gson

/**
 * 此文件中的方法，主要作用是  编解码json文件。及数据封包
 */


/// json字符串解码
fun decode(data: String): HashMap<String, Any> {
//    val ret = HashMap<String, Any>()
    val ret = Gson().fromJson<HashMap<String,Any>>(data, HashMap::class.java);
//    try {
//        val json = JSONObject(data)
//        json.keys().forEach {
//            ret[it] = json[it]
//        }
//        return ret
//    } catch (e: JSONException) {
//        e.printStackTrace()
//
//    }
    return ret
}

/// json编码
fun encode(data: HashMap<String, Any>): String {
//    val params: HashMap<String, Any> = data ?: HashMap<String, Any>()
////    val json = JSONObject((params as Map<*, *>?))
//    val json = Gson().toJson(data)
    return Gson().toJson(data)
}

/// 数据封包
fun wrap(code: Int = 0,
                 data: HashMap<String, Any>? = HashMap<String, Any>(),
                 msg: String = ""): HashMap<String, Any> {
    val ret: HashMap<String, Any> = HashMap<String, Any>()
    ret.put(key = "code", value = code.toString())
    ret.put(key = "data", value = data!!)
    ret.put(key = "msg", value = msg)
    return ret
}