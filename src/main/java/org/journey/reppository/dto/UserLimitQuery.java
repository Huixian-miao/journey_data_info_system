package org.journey.reppository.dto;

import lombok.Data;
import org.hibernate.validator.constraints.Range;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

@Data
public class UserLimitQuery {

    @Min(value = 0, message = "年龄最小为0")
    private Integer age1;
    @Min(value = 0, message = "年龄最小为0")
    private Integer age2;
    @Min(value = 0, message = "飞行里程最小为0")
    private Integer mileAge1;
    @Min(value = 0, message = "飞行里程最小为0")
    private Integer mileAge2;
    @Min(value = 0, message = "飞行时间最小为0")
    private Integer journeyTime1;
    @Min(value = 0, message = "飞行时间最小为0")
    private Integer journeyTime2;


    @Min(value = 1, message = "页码最小为1")
    @NotNull(message = "页码不能为空")
    private Integer page = 1; // 默认值

    @Range(min = 1, max = 20, message = "每页条数需在1-100之间")
    @NotNull(message = "每页条数不能为空")
    private Integer size = 10; // 默认值
}