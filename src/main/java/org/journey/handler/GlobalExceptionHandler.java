package org.journey.handler;

import org.journey.dao.vo.ResponseVO;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.List;
import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ResponseVO<String>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        BindingResult bindingResult = ex.getBindingResult();
        List<FieldError> fieldErrors = bindingResult.getFieldErrors();
        // 拼接每个字段的错误提示
        String errorMsg = fieldErrors.stream()
                .map(error -> error.getField() + ": " + error.getDefaultMessage())
                .collect(Collectors.joining("; "));

        // 构建 ResponseVO，设置状态码、提示信息，这里数据部分可根据需求决定，示例放错误信息
        ResponseVO<String> responseVO = new ResponseVO<>();
        responseVO.setCode(HttpStatus.BAD_REQUEST.value()); // 设置 400 状态码，也可按你项目规范
        responseVO.setMessage(errorMsg);
        responseVO.setData(errorMsg); // 或者根据需要放不同数据，这里简单放错误信息

        return new ResponseEntity<>(responseVO, HttpStatus.BAD_REQUEST);
    }
}