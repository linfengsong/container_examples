package com.example.restapi;

public class GreetingResponse {
	private long id;
	private String content;
	
	public GreetingResponse() {
	}
	
	public GreetingResponse(long id, String content) {
		this.id = id;
		this.content = content;
	}
	
	public long getId() {
		return id;
	}
	
	public String getContent() {
		return content;
	}
	
	public void setId(long id) {
		this.id = id;
	}
	
	public void setContent(String content) {
		this.content = content;
	}
}
