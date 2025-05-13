package com.staxrt.tutorial;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.actuate.autoconfigure.metrics.MeterRegistryCustomizer;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import io.micrometer.core.instrument.MeterRegistry;

/**
 * The type Application.
 *
 * @author Saurabh Sharma
 */
@SpringBootApplication
public class Application {

  /**
   * The entry point of application.
   *
   * @param args the input arguments
   */
  public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}
  
  @Bean
  MeterRegistryCustomizer<MeterRegistry> configurer(
      @Value("${spring.application.name}") String applicationName) {
      return (registry) -> registry.config().commonTags("application", applicationName);
  }
}
