package org.journey.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.journey.dao.PersonJourneyInfoDao;
import org.journey.dao.SelectLimitInfoDao;
import org.journey.dao.dto.UserLimitQuery;
import org.journey.dao.vo.ResponseVO;
import org.journey.entity.PersonJourneyInfo;
import org.journey.entity.SelectLimitInfo;
import org.journey.service.PersonJourneyInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.validation.Valid;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

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
    
    @Override
    public List<Integer> queryAgeRangeCounts(List<Map<String, Integer>> ageRanges) {
        List<Integer> counts = new ArrayList<>();
        LocalDate today = LocalDate.now();
        int currentYear = today.getYear();
        
        for (Map<String, Integer> range : ageRanges) {
            Integer minAge = range.get("minAge");
            Integer maxAge = range.get("maxAge");
            
            if (minAge != null && maxAge != null) {
                int birthYear2 = currentYear - minAge;
                int birthYear1 = currentYear - maxAge;
                
                // 调用DAO方法查询该年龄区间的记录数
                List<PersonJourneyInfo> records = personJourneyInfoDao.queryAllByLimit(
                    birthYear1, birthYear2, 0, 0, 0, 0, 0, Integer.MAX_VALUE, currentYear);
                
                counts.add(records.size());
            } else {
                counts.add(0);
            }
        }
        
        return counts;
    }
    
    @Override
    public Map<String, List<String>> getQueryOptions() {
        Map<String, List<String>> options = new HashMap<>();
        
        // 获取所有数据用于生成选项
        List<PersonJourneyInfo> allRecords = personJourneyInfoDao.selectList(null);
        
        // 性别选项
        List<String> genders = allRecords.stream()
            .map(info -> info.getGender() == 1 ? "男" : "女")
            .filter(Objects::nonNull)
            .distinct()
            .collect(Collectors.toList());
        options.put("gender", genders);
        
        // 年龄范围选项（预设一些常用范围）
        List<String> ageRanges = Arrays.asList("0-18", "19-30", "31-50", "51-65", "65+");
        options.put("ageRange", ageRanges);
        
        // 旅行时间范围选项
        List<String> journeyTimeRanges = Arrays.asList("0-10小时", "10-20小时", "20-50小时", "50+小时");
        options.put("journeyTimeRange", journeyTimeRanges);
        
        // 旅行里程范围选项
        List<String> mileageRanges = Arrays.asList("0-100公里", "100-500公里", "500-1000公里", "1000+公里");
        options.put("mileageRange", mileageRanges);
        
        return options;
    }
}

