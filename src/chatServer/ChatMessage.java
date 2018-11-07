package chatServer;

import com.google.gson.Gson;

@SuppressWarnings("unused")
public class ChatMessage {
	private String message;
	private Integer fromId;
	private Integer toId;
	private long time;
	
	public ChatMessage(String message, Integer from, Integer to, long time) {
		this.message = message;
		this.fromId = from;
		this.toId = to;
		this.time = time;
	}
	
	public String jsonStringify() {
		return new Gson().toJson(this);
	}
	
	public static void main(String [] args) {
		ChatMessage cm = new ChatMessage("Hellooo", 1, 3, System.currentTimeMillis());
		System.out.println(cm.jsonStringify());
	}
}
