package org.journey.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.journey.reppository.PersonJourneyInfoDao;
import org.journey.reppository.SelectLimitInfoDao;
import org.journey.reppository.dto.UserLimitQuery;
import org.journey.reppository.vo.ResponseVO;
import org.journey.entity.PersonJourneyInfo;
import org.journey.entity.SelectLimitInfo;
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

    @Autowired
    private SelectLimitInfoDao selectLimitInfoDao;
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
        if(userLimitQuery.getAge2() !=0){
            SelectLimitInfo selectLimitInfo = new SelectLimitInfo();
            selectLimitInfo.setColumnKey(1);
            selectLimitInfo.setMinValue(userLimitQuery.getAge1());
            selectLimitInfo.setMaxValue(userLimitQuery.getAge2());
            long count = selectLimitInfoDao.count(selectLimitInfo);
            //当前查询条件未保存，那么保存下
            if(count==0){
                selectLimitInfoDao.insert(selectLimitInfo);
            }
        }else{
            birthYear1=0;
            birthYear2=0;
        }
        if(mileAge2 !=0){
            SelectLimitInfo selectLimitInfo = new SelectLimitInfo();
            selectLimitInfo.setColumnKey(2);
            selectLimitInfo.setMinValue(userLimitQuery.getMileAge1());
            selectLimitInfo.setMaxValue(userLimitQuery.getMileAge2());
            long count = selectLimitInfoDao.count(selectLimitInfo);
            //当前查询条件未保存，那么保存下
            if(count==0){
                selectLimitInfoDao.insert(selectLimitInfo);
            }
        }
        if(journeyTime2 !=0){
            SelectLimitInfo selectLimitInfo = new SelectLimitInfo();
            selectLimitInfo.setColumnKey(2);
            selectLimitInfo.setMinValue(userLimitQuery.getJourneyTime1());
            selectLimitInfo.setMaxValue(userLimitQuery.getJourneyTime2());
            long count = selectLimitInfoDao.count(selectLimitInfo);
            //当前查询条件未保存，那么保存下
            if(count==0){
                selectLimitInfoDao.insert(selectLimitInfo);
            }
        }
        List<PersonJourneyInfo> personJourneyInfos = personJourneyInfoDao.queryAllByLimit(birthYear1, birthYear2,
                mileAge1, mileAge2, journeyTime1, journeyTime2, offset, size,currentYear);
        return ResponseVO.success(personJourneyInfos);
    }

    @Override
    public ResponseVO<List<SelectLimitInfo>> querySelectLimitInfoByColumnKey(SelectLimitInfo selectLimitInfo) {
        List<SelectLimitInfo> selectLimitInfos = selectLimitInfoDao.queryAllByLimit(selectLimitInfo);
        return ResponseVO.success(selectLimitInfos);
    }
}

