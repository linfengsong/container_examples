package com.example.restapi;

import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;
import org.springframework.web.bind.annotation.*;

@SpringBootApplication
@RestController
public class RestApiApplication {


//test
	@GetMapping("/")
	public String home() {
		return "Spring is here!";
	}

	public static void main(String[] args) {
		SpringApplication.run(RestApiApplication.class, args);
	}
}
