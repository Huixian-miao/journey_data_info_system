package org.journey.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.journey.entity.SavedQueryCondition;

import java.util.List;

/**
 * 保存的查询条件Mapper接口
 *
 * @author makejava
 * @since 2025-01-XX
 */
@Mapper
public interface SavedQueryConditionMapper extends BaseMapper<SavedQueryCondition> {

    /**
     * 根据用户ID查询所有有效的查询条件
     *
     * @param userId 用户ID
     * @return 查询条件列表
     */
    List<SavedQueryCondition> selectByUserId(@Param("userId") String userId);

    /**
     * 根据用户ID和查询类型查询查询条件
     *
     * @param userId 用户ID
     * @param queryType 查询类型
     * @return 查询条件列表
     */
    List<SavedQueryCondition> selectByUserIdAndType(@Param("userId") String userId, @Param("queryType") String queryType);

    /**
     * 软删除查询条件（设置isActive为0）
     *
     * @param id 查询条件ID
     * @return 影响行数
     */
    int softDeleteById(@Param("id") Long id);
} 