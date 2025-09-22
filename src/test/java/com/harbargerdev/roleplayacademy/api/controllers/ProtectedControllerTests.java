package com.harbargerdev.roleplayacademy.api.controllers;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;

@WebMvcTest(ProtectedController.class)
@ActiveProfiles("test")
public class ProtectedControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @WithMockUser(roles = "USER")
    void protectedEndpointWithRoleUserReturnsOk() throws Exception {
        mockMvc.perform(get("/api/protected"))
                .andExpect(status().isOk())
                .andExpect(content().string("Hello, Protected World!"));
    }

    @Test
    void protectedEndpointWithoutAuthReturnsUnauthorized() throws Exception {
        mockMvc.perform(get("/api/protected"))
                .andExpect(status().isUnauthorized());
    }
}