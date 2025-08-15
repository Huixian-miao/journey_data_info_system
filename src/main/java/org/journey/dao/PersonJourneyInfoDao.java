package org.journey.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import org.journey.entity.PersonJourneyInfo;

import java.util.List;

/**
 * 人员旅行信息表(PersonJourneyInfo)表数据库访问层
 *
 * @author makejava
 * @since 2025-08-09 21:45:41
 */
public interface PersonJourneyInfoDao extends BaseMapper<PersonJourneyInfo> {

    List<PersonJourneyInfo> queryAllByLimit(@Param("birthYear1") int birthYear1,
                                           @Param("birthYear2") int birthYear2,
                                            @Param("mileAge1") int mileAge1,
                                            @Param("mileAge2") int mileAge2,
                                            @Param("journeyTime1") int journeyTime1,
                                            @Param("journeyTime2") int journeyTime2,
                                          @Param("offset") int offset,
                                          @Param("pageSize") int pageSize);

}

