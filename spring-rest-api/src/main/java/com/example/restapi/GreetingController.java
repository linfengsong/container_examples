package com.example.restapi;

import java.util.concurrent.atomic.AtomicLong;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GreetingController {

	private static final String template = "Hello, %s!";
	private final AtomicLong counter = new AtomicLong();

	@PostMapping(path= RestApiApplication.rootPath + "/greeting", consumes = "application/json", produces = "application/json")  
	public GreetingResponse greeting(@RequestBody GreetingRequest request) {
		return new GreetingResponse(counter.incrementAndGet(), String.format(template, request.getName()));
	}
}

