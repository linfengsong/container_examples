package com.example.restapi;

import java.util.concurrent.atomic.AtomicLong;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class JobController {

	private final AtomicLong counter = new AtomicLong();

	@PostMapping(path= "/job", consumes = "application/json", produces = "application/json")  
	public JobResponse greeting(@RequestBody JobRequest request) {
		JobResponse response = new JobResponse(counter.incrementAndGet());
		response.setName(request.getName());
		response.setAsOfDate(request.getAsOfDate());
		response.setPortfoloio(request.getPortfoloio());
		response.setUnits(100);
		return response;
	}
}

