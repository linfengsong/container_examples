package com.example.restapi;

import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.boot.actuate.autoconfigure.security.servlet.ManagementWebSecurityAutoConfiguration;

@SpringBootApplication(
exclude = { SecurityAutoConfiguration.class,
ManagementWebSecurityAutoConfiguration.class })
@RestController
public class RestApiApplication {

	static final String rootPath = "/spring-rest-api";

	@GetMapping(rootPath + "/")
	public String home() {
		return "Spring is here!";
	}

	public static void main(String[] args) {
		SpringApplication.run(RestApiApplication.class, args);
	}
}
