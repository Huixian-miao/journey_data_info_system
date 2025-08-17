package org.journey.service;

import org.journey.dao.vo.ResponseVO;
import org.journey.entity.SavedQueryCondition;

import java.util.List;
import java.util.Map;

/**
 * 保存的查询条件服务接口
 *
 * @author makejava
 * @since 2025-01-XX
 */
public interface SavedQueryConditionService {

    /**
     * 保存查询条件
     *
     * @param queryName 查询条件名称
     * @param queryType 查询类型
     * @param queryRanges 查询区间
     * @return 保存结果
     */
    ResponseVO<SavedQueryCondition> saveQueryCondition(String queryName, String queryType, List<Map<String, Integer>> queryRanges);

    /**
     * 根据用户ID查询所有有效的查询条件
     *
     * @param userId 用户ID
     * @return 查询条件列表
     */
    ResponseVO<List<SavedQueryCondition>> getQueryConditionsByUserId(String userId);

    /**
     * 根据ID删除查询条件
     *
     * @param id 查询条件ID
     * @return 删除结果
     */
    ResponseVO<Boolean> deleteQueryConditionById(Long id);

    /**
     * 根据ID获取查询条件
     *
     * @param id 查询条件ID
     * @return 查询条件
     */
    ResponseVO<SavedQueryCondition> getQueryConditionById(Long id);
} 