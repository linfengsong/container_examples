package com.example.restapi;

public class PositionResponse {
	private long id;
	private String name;
	private String asOfDate;
	private String portfolio;
	private double units;
	
	public PositionResponse() {
	}
	
	public PositionResponse(long id) {
		this.id = id;
	}
	
	public long getId() {
		return id;
	}
	
	public void setId(long id) {
		this.id = id;
	}
	
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
	
	public double getUnits() {
		return units;
	}
	
	public void setUnits(double units) {
		this.units = units;
	}
}
