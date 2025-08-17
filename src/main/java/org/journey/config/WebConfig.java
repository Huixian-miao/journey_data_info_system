package org.journey.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Web配置类
 * 确保本地开发环境的Web功能正常工作
 */
@Configuration
@Profile("local")
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置静态资源处理
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");
        
        registry.addResourceHandler("/public/**")
                .addResourceLocations("classpath:/public/");
        
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("classpath:/resources/");
        
        registry.addResourceHandler("/META-INF/resources/**")
                .addResourceLocations("classpath:/META-INF/resources/");
    }
} 