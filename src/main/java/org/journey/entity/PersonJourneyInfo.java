package org.journey.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import lombok.Data;

/**
 * 人员旅行信息表(PersonJourneyInfo)表实体类
 *
 * @author makejava
 * @since 2025-08-09 21:45:41
 */
@Data
@TableName("person_journey_info")
public class PersonJourneyInfo extends Model<PersonJourneyInfo> {
    //人员ID
    @TableId("person_id")
    private Integer personId;
    //出生年份
    private Integer birthYear;
    //性别（0-女，1-男）
    private Integer gender;
    //总旅行时间（单位：小时）
    private Double totalJourneyTime;
    //总旅行里程
    private Double totalMileage;
}

