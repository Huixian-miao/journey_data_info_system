package org.journey.reppository;

import org.apache.ibatis.annotations.Param;
import org.journey.entity.SelectLimitInfo;

import java.util.List;

/**
 * 查询条件存储表(SelectLimitInfo)表数据库访问层
 *
 * @author makejava
 * @since 2025-08-16 10:26:46
 */
public interface SelectLimitInfoDao {

    /**
     * 通过ID查询单条数据
     *
     * @param selectLimitInfo 查询条件
     * @return 实例对象
     */
    SelectLimitInfo queryById(SelectLimitInfo selectLimitInfo);

    /**
     * 查询指定行数据
     *
     * @param selectLimitInfo 查询条件
     * @return 对象列表
     */
    List<SelectLimitInfo> queryAllByLimit(SelectLimitInfo selectLimitInfo);

    /**
     * 统计总行数
     *
     * @param selectLimitInfo 查询条件
     * @return 总行数
     */
    int count(SelectLimitInfo selectLimitInfo);

    /**
     * 新增数据
     *
     * @param selectLimitInfo 实例对象
     * @return 影响行数
     */
    int insert(SelectLimitInfo selectLimitInfo);

    /**
     * 批量新增数据（MyBatis原生foreach方法）
     *
     * @param entities List<SelectLimitInfo> 实例对象列表
     * @return 影响行数
     */
    int insertBatch(@Param("entities") List<SelectLimitInfo> entities);

    /**
     * 批量新增或按主键更新数据（MyBatis原生foreach方法）
     *
     * @param entities List<SelectLimitInfo> 实例对象列表
     * @return 影响行数
     * @throws org.springframework.jdbc.BadSqlGrammarException 入参是空List的时候会抛SQL语句错误的异常，请自行校验入参
     */
    int insertOrUpdateBatch(@Param("entities") List<SelectLimitInfo> entities);

    /**
     * 修改数据
     *
     * @param selectLimitInfo 实例对象
     * @return 影响行数
     */
    int update(SelectLimitInfo selectLimitInfo);

    /**
     * 通过主键删除数据
     *
     * @param limitId 主键
     * @return 影响行数
     */
    int deleteById(Integer limitId);

}

