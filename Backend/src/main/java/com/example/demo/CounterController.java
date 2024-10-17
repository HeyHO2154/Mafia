package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class CounterController {

    @Autowired
    private CounterService counterService;

    @PostMapping("/increment")
    public void incrementCounter() {
        counterService.incrementCounter();
    }

    @GetMapping("/value")
    public int getCounterValue() {
        return counterService.getCounterValue();
    }
}
