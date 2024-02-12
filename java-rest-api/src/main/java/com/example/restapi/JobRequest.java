package com.example.restapi;

public class JobRequest {
	private String name;
	private String asOfDate;
	private String portfoloio;
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getAsOfDate() {
		return asOfDate;
	}
	
	public void setAsOfDate(String asOfDate) {
		this.asOfDate = asOfDate;
	}
	
	public String getPortfoloio() {
		return portfoloio;
	}
	
	public void setPortfoloio(String portfoloio) {
		this.portfoloio = portfoloio;
	}
}
