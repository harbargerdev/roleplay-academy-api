package com.harbargerdev.roleplayacademyapi;

import org.springframework.boot.SpringApplication;

public class TestRoleplayacademyapiApplication {

	public static void main(String[] args) {
		SpringApplication.from(RoleplayAcademyApiApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
