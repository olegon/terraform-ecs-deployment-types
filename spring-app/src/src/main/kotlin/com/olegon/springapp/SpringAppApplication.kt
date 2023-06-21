package com.olegon.springapp

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class SpringAppApplication

fun main(args: Array<String>) {
	runApplication<SpringAppApplication>(*args)
}
