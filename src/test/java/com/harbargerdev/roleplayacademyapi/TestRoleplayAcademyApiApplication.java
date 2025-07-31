package com.harbargerdev.roleplayacademyapi;

import org.springframework.boot.SpringApplication;

public class TestRoleplayAcademyApiApplication {

	public static void main(String[] args) {

		// Create a new SpringApplication instance for the RoleplayAcademyApiApplication class.
		SpringApplication application = new SpringApplication(RoleplayAcademyApiApplication.class);
		application.setAdditionalProfiles("test");

		// Run the application with the "test" profile.
		application.run(args);
	}

}
