package org.journey.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;

/**
 * 查询条件存储表(SelectLimitInfo)实体类
 *
 * @author makejava
 * @since 2025-08-16 10:26:46
 */
@Data
@TableName("select_limit_info")
public class SelectLimitInfo implements Serializable {
    private static final long serialVersionUID = 485726487775162594L;
    /**
     * 条件id
     */
    private Integer limitId;
    /**
     * 出生年份:1,总旅行里程:2,总旅行时间:3
     */
    private Integer columnKey;
    /**
     * 较大值
     */
    private Integer maxValue;
    /**
     * 较小值
     */
    private Integer minValue;


}

