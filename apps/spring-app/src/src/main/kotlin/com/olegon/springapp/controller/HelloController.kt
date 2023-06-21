package com.olegon.springapp.controller

import org.springframework.beans.factory.annotation.Value
import org.springframework.hateoas.EntityModel
import org.springframework.hateoas.server.mvc.WebMvcLinkBuilder
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class HelloController(
    @Value("\${app.version}")
    private val version: String
) {
    data class HelloResponse(
        val message: String
    )

    data class Version(
        val version: String
    )

    @GetMapping("/")
    fun sayHello(): EntityModel<HelloResponse> {
        return EntityModel.of(HelloResponse("Hello! :)"),
            WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(HelloController::class.java).sayHello()).withSelfRel(),
        )
    }

    @GetMapping("/v1/version")
    fun getVersion(): EntityModel<Version> {
        return EntityModel.of(Version(version),
            WebMvcLinkBuilder.linkTo(WebMvcLinkBuilder.methodOn(HelloController::class.java).getVersion()).withSelfRel(),
        )
    }
}
