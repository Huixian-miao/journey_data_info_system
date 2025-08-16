package org.journey.controller;


import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.journey.dao.dto.UserLimitQuery;
import org.journey.dao.vo.ResponseVO;
import org.journey.entity.PersonJourneyInfo;
import org.journey.entity.SelectLimitInfo;
import org.journey.service.PersonJourneyInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import java.util.List;

/**
 * 人员旅行信息表(PersonJourneyInfo)表控制层
 *
 * @author makejava
 * @since 2025-08-09 21:45:39
 */
@RestController
@RequestMapping("/personJourneyInfo")
public class PersonJourneyInfoController{

    @Autowired
    private PersonJourneyInfoService personJourneyInfoService;
    // Service
    @PostMapping("/queryByPage")
    public ResponseVO<Page<PersonJourneyInfo>> queryByPage(@RequestBody @Valid UserLimitQuery userLimitQuery) {
        ResponseVO<List<PersonJourneyInfo>> responseVO1 = personJourneyInfoService.queryByLimit(userLimitQuery);
        Page<PersonJourneyInfo> page = new Page<>(userLimitQuery.getPage(), userLimitQuery.getSize());
        if(responseVO1.getCode().equals(201)){
            page.setRecords(null);
            return ResponseVO.fail(responseVO1.getCode(), responseVO1.getMessage());
        }
        page.setRecords(responseVO1.getData());
        return ResponseVO.success(page);// 无条件分页
    }

    @PostMapping("/querySelectLimitInfo")
    public ResponseVO<List<SelectLimitInfo>> querySelectLimitInfoByColumnKey(@RequestBody SelectLimitInfo selectLimitInfo) {
        return personJourneyInfoService.querySelectLimitInfoByColumnKey(selectLimitInfo);
    }
}

