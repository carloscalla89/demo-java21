package com.example.demo.controller;

import com.example.demo.model.WorkloadParameterRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

@RequestMapping("/shrd/exchange-rates")
@Slf4j
@RequiredArgsConstructor
@RestController
public class DemoController {

  @GetMapping(value = "/retrieve",
          produces = { APPLICATION_JSON_VALUE })
  public String getMessage(WorkloadParameterRequest workloadParameterRequest) {

    log.info("[START endpoint] - {}",workloadParameterRequest);

    return "success";

  }
}
