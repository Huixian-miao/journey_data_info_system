package org.journey.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller // 注意：是 @Controller，不是 @RestController！
@RequestMapping("/person")
public class PersonJourneyInfoJspController{

    @GetMapping("/journeyInfo")
    public String showJspPage() {
        // 返回的字符串是 JSP 的逻辑名，会被视图解析器处理
        return "personJourneyInfo";
    }

    @GetMapping("/test")
    public String testJsp() {
        return "test"; // 对应 webapp/person/test.jsp
    }
}