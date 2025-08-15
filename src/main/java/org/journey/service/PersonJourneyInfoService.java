package org.journey.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.journey.dao.dto.UserLimitQuery;
import org.journey.dao.vo.ResponseVO;
import org.journey.entity.PersonJourneyInfo;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import javax.validation.Valid;
import java.util.List;

/**
 * 人员旅行信息表(PersonJourneyInfo)表服务接口
 *
 * @author makejava
 * @since 2025-08-09 21:45:42
 */
@Service
public interface PersonJourneyInfoService extends IService<PersonJourneyInfo> {

    ResponseVO<List<PersonJourneyInfo>> queryByLimit(@RequestBody @Valid UserLimitQuery userLimitQuery);


}

