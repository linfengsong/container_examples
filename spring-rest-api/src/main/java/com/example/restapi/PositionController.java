package com.example.restapi;

import java.util.concurrent.atomic.AtomicLong;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PositionController {

	private final AtomicLong counter = new AtomicLong();

	@PostMapping(path= RestApiApplication.rootPath + "/position", consumes = "application/json", produces = "application/json")  
	public PositionResponse position(@RequestBody PositionRequest request) {
		PositionResponse response = new PositionResponse(counter.incrementAndGet());
		response.setName(request.getName());
		response.setAsOfDate(request.getAsOfDate());
		response.setPortfolio(request.getPortfolio());
		response.setUnits(100);
		return response;
	}
}

