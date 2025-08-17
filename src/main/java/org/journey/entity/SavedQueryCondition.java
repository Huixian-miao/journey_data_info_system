package org.journey.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDateTime;

/**
 * 保存的查询条件实体类
 *
 * @author makejava
 * @since 2025-01-XX
 */
@TableName("saved_query_conditions")
public class SavedQueryCondition {

    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 用户ID（默认用户）
     */
    private String userId;

    /**
     * 查询条件名称
     */
    private String queryName;

    /**
     * 查询类型（age/mileage/time）
     */
    private String queryType;

    /**
     * 查询区间JSON格式
     */
    private String queryRanges;

    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdTime;

    /**
     * 更新时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedTime;

    /**
     * 是否有效
     */
    private Integer isActive;

    public SavedQueryCondition() {
    }

    public SavedQueryCondition(String queryName, String queryType, String queryRanges) {
        this.queryName = queryName;
        this.queryType = queryType;
        this.queryRanges = queryRanges;
        this.userId = "default_user"; // 默认用户
        this.isActive = 1;
        this.createdTime = LocalDateTime.now();
        this.updatedTime = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getQueryName() {
        return queryName;
    }

    public void setQueryName(String queryName) {
        this.queryName = queryName;
    }

    public String getQueryType() {
        return queryType;
    }

    public void setQueryType(String queryType) {
        this.queryType = queryType;
    }

    public String getQueryRanges() {
        return queryRanges;
    }

    public void setQueryRanges(String queryRanges) {
        this.queryRanges = queryRanges;
    }

    public LocalDateTime getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(LocalDateTime createdTime) {
        this.createdTime = createdTime;
    }

    public LocalDateTime getUpdatedTime() {
        return updatedTime;
    }

    public void setUpdatedTime(LocalDateTime updatedTime) {
        this.updatedTime = updatedTime;
    }

    public Integer getIsActive() {
        return isActive;
    }

    public void setIsActive(Integer isActive) {
        this.isActive = isActive;
    }

    @Override
    public String toString() {
        return "SavedQueryCondition{" +
                "id=" + id +
                ", userId='" + userId + '\'' +
                ", queryName='" + queryName + '\'' +
                ", queryType='" + queryType + '\'' +
                ", queryRanges='" + queryRanges + '\'' +
                ", createdTime=" + createdTime +
                ", updatedTime=" + updatedTime +
                ", isActive=" + isActive +
                '}';
    }
} 