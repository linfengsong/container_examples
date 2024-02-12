package com.example.restapi;

public class JobResponse {
	private long id;
	private String name;
	private String asOfDate;
	private String portfoloio;
	private double units;
	
	public JobResponse() {
	}
	
	public JobResponse(long id) {
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
	
	public String getPortfoloio() {
		return portfoloio;
	}
	
	public void setPortfoloio(String portfoloio) {
		this.portfoloio = portfoloio;
	}
	
	public double getUnits() {
		return units;
	}
	
	public void setUnits(double units) {
		this.units = units;
	}
}
