package org.example.api;

import io.qameta.allure.Allure;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.http.Method;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.apache.commons.io.IOUtils;
import org.example.api.gherkintypes.RequestModel;
import org.example.api.listeners.RestAssuredCustomLogger;
import org.example.utils.FileUtil;
import org.example.utils.JsonUtil;
import org.example.utils.RegexUtil;

import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static org.example.api.testcontext.ContextHolder.replaceVarsIfPresent;


public class ApiRequest {

    private final Method method;
    private String body;
    private Response response;

    private final RequestSpecBuilder builder;

    public ApiRequest(RequestModel requestModel) {
        this.builder = new RequestSpecBuilder();
        this.method = Method.valueOf(requestModel.getMethod());
        this.body = requestModel.getBody();
        String fullUrl = replaceVarsIfPresent(requestModel.getUrl());
        URI uri = URI.create(fullUrl);
        this.builder.setBaseUri(uri);
        setBodyFromFile();
        addLoggingListener();
    }

    public Response getResponse() {
        return response;
    }

    /**
     * Сеттит заголовки
     */
    public void setHeaders(Map<String, String> headers) {
        headers.forEach((k, v) -> {
            builder.addHeader(k, v);
        });
    }

    /**
     * Сеттит query-параметры
     */
    public void setQuery(Map<String, String> query) {
        query.forEach((k, v) -> {
            builder.addQueryParam(k, v);
        });
    }

    /**
     * Отправляет сформированный запрос
     */
    public void sendRequest() {
        RequestSpecification requestSpecification = builder.build();

        Response response = given()
                .spec(requestSpecification)
                .request(method);

        attachRequestResponseToAllure(response, body);
        this.response = response;
    }

    /**
     * Сессит тело запроса из файла
     */
    private void setBodyFromFile() {
        if (body != null && RegexUtil.getMatch(body, ".*\\.json")) {
            body = replaceVarsIfPresent(FileUtil.readBodyFromJsonDir(body));
            builder.setBody(body);
        }
    }

    /**
     * Аттачит тело запроса и тело ответа в шаг отправки запроса
     */
    private void attachRequestResponseToAllure(Response response, String requestBody) {
        if (requestBody != null) {
            Allure.addAttachment(
                    "Request",
                    "application/json",
                    IOUtils.toInputStream(requestBody, StandardCharsets.UTF_8),
                    ".txt");
        }
        String responseBody = JsonUtil.jsonToUtf(response.body().asPrettyString());
        Allure.addAttachment("Response", "application/json", responseBody, ".txt");
    }

    /**
     * Добавляет логгер, печатающий в консоль данные запросов и ответов
     */
    private void addLoggingListener() {
        builder.addFilter(new RestAssuredCustomLogger());
    }
}

