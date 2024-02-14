package com.example.restapi;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.beans.factory.annotation.Autowired;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
class RestApiApplicationTests {

	@Test
	void contextLoads() {
	}

	@Autowired
	private TestRestTemplate restTemplate;

	@Test
	void homeResponse() {
		String body = this.restTemplate.getForObject(RestApiApplication.rootPath + "/", String.class);
		assertEquals("Spring is here!", body);
	}
	
	@Test
	void greetingResponse() throws Exception{
		GreetingRequest requst = new GreetingRequest();
		requst.setName("Tester");
		GreetingResponse response = this.restTemplate.postForObject(RestApiApplication.rootPath + "/greeting", requst, GreetingResponse.class);
		assertEquals("Hello, Tester!", response.getContent());
	}
	
	@Test
	void positionResponse() throws Exception{
		PositionRequest requst = new PositionRequest();
		requst.setName("TestJob");
		requst.setAsOfDate("2024-02-01");
		requst.setPortfolio("abc123");
		PositionResponse response = this.restTemplate.postForObject(RestApiApplication.rootPath + "/position", requst, PositionResponse.class);
		assertEquals("TestJob", response.getName());
	}
}
