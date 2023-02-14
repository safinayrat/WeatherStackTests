package org.example.api.gherkintypes;

import io.cucumber.java.DataTableType;

import java.util.Map;

public class DataTableTypeContainer {

    @DataTableType
    public RequestModel requestModel(Map<String, String> entry) {
        return new RequestModel(
                entry.get("method"),
                entry.get("body"),
                entry.get("url")
        );
    }
}
