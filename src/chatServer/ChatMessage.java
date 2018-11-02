package chatServer;

import com.google.gson.Gson;

public class ChatMessage {
	private String message;
	private Integer fromId;
	private Integer toId;
	
	public ChatMessage(String message, Integer from, Integer to) {
		this.message = message;
		this.fromId = from;
		this.toId = to;
	}
	
	public String jsonStringify() {
		return new Gson().toJson(this);
	}
}
