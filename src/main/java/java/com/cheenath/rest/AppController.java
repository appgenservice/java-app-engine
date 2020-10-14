package com.cheenath.rest;
import com.cheenath.data.App;
import com.cheenath.data.AppRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

@RestController
@RequestMapping("/app")
public class AppController {
    private final String APP_NAME="app-";
    private final int PORT_NUMBER_BASE = 9000;
    @Autowired
    private AppRepository appRepository;
    @GetMapping
    public App getApp(@RequestParam(value = "appId") Long appId) {
        return appRepository.findById(appId).orElse(null);
    }
    @GetMapping(value = "/list")
    public Iterable<App> getAllApps() {
        return appRepository.findAll();
    }

    @PostMapping
    public App addApp() {
        int nextAppId = appRepository.findMaxAppId() != null ? appRepository.findMaxAppId().intValue() + 1 : 1;
        return appRepository.save(new App(nextAppId, APP_NAME + nextAppId, PORT_NUMBER_BASE + nextAppId, new Date()));
    }

    @DeleteMapping
    public void deleteApp(@RequestParam(value = "appId") Long appId) {
        appRepository.deleteById(appId);
    }

}
