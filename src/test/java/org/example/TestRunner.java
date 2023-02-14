package org.example;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;
import org.testng.annotations.DataProvider;

@CucumberOptions(
        plugin = {"pretty", "io.qameta.allure.cucumber6jvm.AllureCucumber6Jvm"},
        features = "src/test/resources",
        glue = {"org.example"},
        tags = "@test"
)
public class TestRunner extends AbstractTestNGCucumberTests {

    @Override
    @DataProvider(parallel = true)
    public Object[][] scenarios() {
        return super.scenarios();
    }
}
