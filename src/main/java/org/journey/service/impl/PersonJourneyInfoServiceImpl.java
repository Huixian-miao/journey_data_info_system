package org.journey.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.journey.dao.PersonJourneyInfoDao;
import org.journey.dao.dto.UserLimitQuery;
import org.journey.dao.vo.ResponseVO;
import org.journey.entity.PersonJourneyInfo;
import org.journey.service.PersonJourneyInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.validation.Valid;
import java.time.LocalDate;
import java.util.List;

/**
 * 人员旅行信息表(PersonJourneyInfo)表服务实现类
 *
 * @author makejava
 * @since 2025-08-09 21:45:42
 */
@Service("personJourneyInfoService")
public class PersonJourneyInfoServiceImpl extends ServiceImpl<PersonJourneyInfoDao, PersonJourneyInfo> implements PersonJourneyInfoService {

    @Autowired
    private PersonJourneyInfoDao personJourneyInfoDao;
    //调用自定义Mapper方法（需XML或注解SQL）
    @Override
    public ResponseVO<List<PersonJourneyInfo>> queryByLimit(@Valid UserLimitQuery userLimitQuery){
        Integer page = userLimitQuery.getPage();
        Integer size = userLimitQuery.getSize();
        //获取当前年份
        LocalDate today = LocalDate.now();
        int currentYear = today.getYear();

        int birthYear2 = currentYear-userLimitQuery.getAge1();
        int birthYear1 = currentYear-userLimitQuery.getAge2();
        int mileAge1 = userLimitQuery.getMileAge1();
        int mileAge2 = userLimitQuery.getMileAge2();
        int journeyTime1 = userLimitQuery.getJourneyTime1();
        int journeyTime2 = userLimitQuery.getJourneyTime2();
        int offset = (page - 1) * size;
        if(birthYear1 > birthYear2 || mileAge1 >mileAge2 || journeyTime1>journeyTime2){
            return ResponseVO.fail(201,"参数有误，请核实！");
        }
        List<PersonJourneyInfo> personJourneyInfos = personJourneyInfoDao.queryAllByLimit(birthYear1, birthYear2,
                mileAge1, mileAge2, journeyTime1, journeyTime2, offset, size);
        return ResponseVO.success(personJourneyInfos);
    }
}

