package com.harbargerdev.roleplayacademyapi.controllers;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ProtectedController {

    @PreAuthorize("hasRole('USER')")
    @GetMapping("/api/protected")
    public String protectedHello() {
        return "Hello, Protected World!";
    }
}
