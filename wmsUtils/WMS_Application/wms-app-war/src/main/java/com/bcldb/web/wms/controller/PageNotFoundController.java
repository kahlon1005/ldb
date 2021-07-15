package com.bcldb.web.wms.controller;

import org.springframework.boot.autoconfigure.web.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class PageNotFoundController implements ErrorController{
    private final static String PATH = "/error";
    @Override
    @RequestMapping(value = PATH, method = RequestMethod.GET)    
    public String getErrorPath() {       
        return "redirect:/";
    }

}