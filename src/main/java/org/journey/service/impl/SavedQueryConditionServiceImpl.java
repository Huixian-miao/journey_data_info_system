package org.journey.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.journey.dao.SavedQueryConditionMapper;
import org.journey.dao.vo.ResponseVO;
import org.journey.entity.SavedQueryCondition;
import org.journey.service.SavedQueryConditionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 保存的查询条件服务实现类
 *
 * @author makejava
 * @since 2025-01-XX
 */
@Service
public class SavedQueryConditionServiceImpl implements SavedQueryConditionService {

    @Autowired
    private SavedQueryConditionMapper savedQueryConditionMapper;

    @Autowired
    private ObjectMapper objectMapper;

    @Override
    public ResponseVO<SavedQueryCondition> saveQueryCondition(String queryName, String queryType, List<Map<String, Integer>> queryRanges) {
        try {
            // 将查询区间转换为JSON字符串
            String queryRangesJson = objectMapper.writeValueAsString(queryRanges);
            
            // 创建查询条件对象
            SavedQueryCondition queryCondition = new SavedQueryCondition(queryName, queryType, queryRangesJson);
            
            // 保存到数据库
            int result = savedQueryConditionMapper.insert(queryCondition);
            
            if (result > 0) {
                return ResponseVO.success(queryCondition);
            } else {
                return ResponseVO.fail(500, "保存查询条件失败");
            }
        } catch (JsonProcessingException e) {
            return ResponseVO.fail(500, "查询区间格式转换失败：" + e.getMessage());
        } catch (Exception e) {
            return ResponseVO.fail(500, "保存查询条件失败：" + e.getMessage());
        }
    }

    @Override
    public ResponseVO<List<SavedQueryCondition>> getQueryConditionsByUserId(String userId) {
        try {
            QueryWrapper<SavedQueryCondition> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("user_id", userId)
                       .eq("is_active", 1)
                       .orderByDesc("created_time");
            
            List<SavedQueryCondition> queryConditions = savedQueryConditionMapper.selectList(queryWrapper);
            return ResponseVO.success(queryConditions);
        } catch (Exception e) {
            return ResponseVO.fail(500, "查询保存的查询条件失败：" + e.getMessage());
        }
    }

    @Override
    public ResponseVO<Boolean> deleteQueryConditionById(Long id) {
        try {
            // 软删除，设置isActive为0
            SavedQueryCondition queryCondition = new SavedQueryCondition();
            queryCondition.setId(id);
            queryCondition.setIsActive(0);
            queryCondition.setUpdatedTime(LocalDateTime.now());
            
            int result = savedQueryConditionMapper.deleteById(queryCondition);
            
            if (result > 0) {
                return ResponseVO.success(true);
            } else {
                return ResponseVO.fail(500, "删除查询条件失败");
            }
        } catch (Exception e) {
            return ResponseVO.fail(500, "删除查询条件失败：" + e.getMessage());
        }
    }

    @Override
    public ResponseVO<SavedQueryCondition> getQueryConditionById(Long id) {
        try {
            SavedQueryCondition queryCondition = savedQueryConditionMapper.selectById(id);
            if (queryCondition != null && queryCondition.getIsActive() == 1) {
                return ResponseVO.success(queryCondition);
            } else {
                return ResponseVO.fail(404, "查询条件不存在或已删除");
            }
        } catch (Exception e) {
            return ResponseVO.fail(500, "查询条件获取失败：" + e.getMessage());
        }
    }
} 