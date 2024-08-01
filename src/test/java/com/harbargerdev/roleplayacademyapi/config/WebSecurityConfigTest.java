package com.harbargerdev.roleplayacademyapi.config;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public class WebSecurityConfigTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void whenAccessPublicEndpoint_thenOk() throws Exception {
        mockMvc.perform(get("/api/hello"))
            .andExpect(status().isOk());
    }

    @Test
    public void whenAccessActuatorEndpoint_thenOk() throws Exception {
        mockMvc.perform(get("/actuator/health"))
            .andExpect(status().isOk());
    }

    @Test
    public void whenAccessProtectedEndpoint_thenUnauthorized() throws Exception {
        mockMvc.perform(get("/api/protected"))
            .andExpect(status().isForbidden());
    }
}
