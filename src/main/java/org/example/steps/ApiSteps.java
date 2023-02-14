package org.example.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.ru.И;
import io.qameta.allure.Allure;
import org.example.api.ApiRequest;
import org.example.api.gherkintypes.RequestModel;
import org.example.api.testcontext.ContextHolder;
import org.example.utils.CompareUtil;
import org.example.utils.DataGenerator;
import org.example.utils.VariableUtil;
import org.junit.Assert;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testng.asserts.SoftAssert;

import java.util.HashMap;
import java.util.Map;

import static org.example.api.testcontext.ContextHolder.replaceVarsIfPresent;
import static org.example.utils.JsonUtil.getFieldFromJson;


public class ApiSteps {

    private static final Logger LOG = LoggerFactory.getLogger(ApiSteps.class);
    private ApiRequest apiRequest;
    private final SoftAssert softAssertion = new SoftAssert();

    @И("создать запрос")
    public void createRequest(RequestModel requestModel) {
        apiRequest = new ApiRequest(requestModel);
    }

    @И("добавить header")
    public void addHeaders(DataTable dataTable) {
        Map<String, String> headers = new HashMap<>();
        dataTable.asLists().forEach(it -> headers.put(it.get(0), it.get(1)));
        apiRequest.setHeaders(headers);
    }

    @И("добавить query параметры")
    public void addQuery(DataTable dataTable) {
        Map<String, String> query = new HashMap<>();
        dataTable.asLists().forEach(it -> query.put(it.get(0), it.get(1)));
        apiRequest.setQuery(query);
    }

    @И("отправить запрос")
    public void send() {
        apiRequest.sendRequest();
    }

    @И("статус код {int}")
    public void expectStatusCode(int code) {
        int actualStatusCode = apiRequest.getResponse().statusCode();
        Assert.assertEquals(actualStatusCode, code);
    }

    @И("извлечь данные")
    public void extractVariables(Map<String, String> vars) {
        String responseBody = apiRequest.getResponse().body().asPrettyString();
        vars.forEach((k, jsonPath) -> {
            String extractedValue = VariableUtil.extractBrackets(getFieldFromJson(responseBody, jsonPath));
            ContextHolder.put(k, extractedValue);
            Allure.addAttachment(k, "application/json", extractedValue, ".txt");
            LOG.info("Извлечены данные: {}={}", k, extractedValue);
        });
    }

    @И("сгенерировать переменные")
    public void generateVariablesByMask(Map<String, String> table) {
        table.forEach((k, v) -> {
            String value = DataGenerator.generateValueByMask(replaceVarsIfPresent(v));
            ContextHolder.put(k, value);
            Allure.addAttachment(k, "application/json", k + ": " + value, ".txt");
            LOG.info("Сгенерирована переменная: {}={}", k, value);
        });
    }

    @И("создать контекстные переменные")
    public void createContextVariables(Map<String, String> table) {
        table.forEach((k, v) -> {
            ContextHolder.put(k, v);
            LOG.info("Сохранена переменная: {}={}", k, v);
        });
    }

    @И("сравнить значения")
    public void compareVars(DataTable table) {
        table.asLists().forEach(it -> {
            String expect = replaceVarsIfPresent(it.get(0));
            String actual = replaceVarsIfPresent(it.get(2));
            boolean compareResult = CompareUtil.compare(expect, actual, it.get(1));
            softAssertion.assertTrue(compareResult, String.format("Ожидаемое: '%s'\nФактическое: '%s'\n", expect, actual));
            Allure.addAttachment(expect, "application/json", expect + it.get(1) + actual, ".txt");
            LOG.info("Сравнение значений: {} {} {}", expect, it.get(1), actual);
        });
    }

    @И("получить результат теста")
    public void getTestResult() {
        softAssertion.assertAll();
    }
}