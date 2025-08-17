package org.journey.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/test")
public class TestController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello, Spring Boot is running!";
    }
    
    @GetMapping("/health")
    public String health() {
        return "Service is healthy!";
    }
} 