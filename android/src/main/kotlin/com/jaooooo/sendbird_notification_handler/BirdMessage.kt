package com.jaooooo.sendbird_notification_handler

import org.json.JSONObject

data class BirdMessage(
    val message: String,
    val channelUrl: String,
    val senderId: String,
    val type: String,
    val senderName: String?,
    val senderProfileUrl: String?,
) {
    companion object {
        fun fromJson(json: JSONObject): BirdMessage {
            val channel = json.getJSONObject("channel")
            val sender = json.getJSONObject("sender")

            return BirdMessage(
                message = json.getString("message"),
                channelUrl = channel.getString("channel_url"),
                senderId = sender.getString("id"),
                type = json.getString("type"),
                senderName = sender.optString("name"),
                senderProfileUrl = json.optString("profile_url"),
            )
        }
    }

    fun toJson(): JSONObject {
        val json = JSONObject()
        json.put("message", message)
        json.put("channelUrl", channelUrl)
        json.put("senderId", senderId)
        json.put("type", type)
        json.put("senderName", senderName)
        json.put("senderProfileUrl", senderProfileUrl)
        return json
    }
}
