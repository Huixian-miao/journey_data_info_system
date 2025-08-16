
package org.journey.reppository.vo;
import lombok.Data;
import java.io.Serializable;

/**
 * 通用响应封装类
 * @param <T> 响应数据类型
 */
@Data
public class ResponseVO<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer code;    // 状态码
    private String message; // 提示信息
    private T data;         // 响应数据
    // 新增 public 构造方法
    public ResponseVO() {}

    public ResponseVO(Integer code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    // ------------ 快速构建方法 ------------
    /**
     * 成功响应（无数据）
     */
    public static <T> ResponseVO<T> success() {
        return new ResponseVO<>(200, "success", null);
    }

    /**
     * 成功响应（带数据）
     */
    public static <T> ResponseVO<T> success(T data) {
        return new ResponseVO<>(200, "success", data);
    }

    /**
     * 成功响应（自定义消息）
     */
    public static <T> ResponseVO<T> success(String message, T data) {
        return new ResponseVO<>(200, message, data);
    }

    /**
     * 失败响应（默认状态码）
     */
    public static <T> ResponseVO<T> fail(String message) {
        return new ResponseVO<>(500, message, null);
    }

    /**
     * 失败响应（自定义状态码）
     */
    public static <T> ResponseVO<T> fail(Integer code, String message) {
        return new ResponseVO<>(code, message, null);
    }

    // ------------ 链式调用方法 ------------
    public ResponseVO<T> code(Integer code) {
        this.code = code;
        return this;
    }

    public ResponseVO<T> message(String message) {
        this.message = message;
        return this;
    }

    public ResponseVO<T> data(T data) {
        this.data = data;
        return this;
    }
}