package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CounterService {

    @Autowired
    private CounterRepository counterRepository;

    public void incrementCounter() {
        Counter counter = counterRepository.findById(1).orElse(new Counter());
        counter.setId(1);
        counter.setValue(counter.getValue() + 1);
        counterRepository.save(counter);
    }

    public int getCounterValue() {
        return counterRepository.findById(1).map(Counter::getValue).orElse(0);
    }
}
