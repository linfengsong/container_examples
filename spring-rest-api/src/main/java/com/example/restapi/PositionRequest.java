package com.example.restapi;

public class PositionRequest {
	private String name;
	private String asOfDate;
	private String portfolio;
	
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
	
	public String getPortfolio() {
		return portfolio;
	}
	
	public void setPortfolio(String portfolio) {
		this.portfolio = portfolio;
	}
}
