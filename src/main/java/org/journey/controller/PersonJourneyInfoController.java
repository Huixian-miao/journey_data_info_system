package org.journey.controller;


import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.journey.dao.dto.UserLimitQuery;
import org.journey.dao.vo.ResponseVO;
import org.journey.entity.PersonJourneyInfo;
import org.journey.entity.SavedQueryCondition;
import org.journey.entity.SelectLimitInfo;
import org.journey.service.PersonJourneyInfoService;
import org.journey.service.SavedQueryConditionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import java.util.List;
import java.util.Map;

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
	
	@Autowired
	private SavedQueryConditionService savedQueryConditionService;
	
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
	
	/**
	 * 按年龄区间查询
	 */
	@PostMapping("/queryByAgeRanges")
	public ResponseVO<List<PersonJourneyInfo>> queryByAgeRanges(@RequestBody Map<String, List<Map<String, Integer>>> request) {
		try {
			List<Map<String, Integer>> ageRanges = request.get("ageRanges");
			List<PersonJourneyInfo> result = personJourneyInfoService.queryByAgeRanges(ageRanges);
			return ResponseVO.success(result);
		} catch (Exception e) {
			return ResponseVO.fail(500, "按年龄区间查询失败：" + e.getMessage());
		}
	}
	
	/**
	 * 按里程区间查询
	 */
	@PostMapping("/queryByMileageRanges")
	public ResponseVO<List<PersonJourneyInfo>> queryByMileageRanges(@RequestBody Map<String, List<Map<String, Integer>>> request) {
		try {
			List<Map<String, Integer>> mileageRanges = request.get("mileageRanges");
			List<PersonJourneyInfo> result = personJourneyInfoService.queryByMileageRanges(mileageRanges);
			return ResponseVO.success(result);
		} catch (Exception e) {
			return ResponseVO.fail(500, "按里程区间查询失败：" + e.getMessage());
		}
	}
	
	/**
	 * 按时间区间查询
	 */
	@PostMapping("/queryByTimeRanges")
	public ResponseVO<List<PersonJourneyInfo>> queryByTimeRanges(@RequestBody Map<String, List<Map<String, Integer>>> request) {
		try {
			List<Map<String, Integer>> timeRanges = request.get("timeRanges");
			List<PersonJourneyInfo> result = personJourneyInfoService.queryByTimeRanges(timeRanges);
			return ResponseVO.success(result);
		} catch (Exception e) {
			return ResponseVO.fail(500, "按时间区间查询失败：" + e.getMessage());
		}
	}
	
	/**
	 * 年龄区间统计接口
	 */
	@PostMapping("/queryAgeRangeCounts")
	public ResponseVO<List<Integer>> queryAgeRangeCounts(@RequestBody List<Map<String, Integer>> ageRanges) {
		try {
			List<Integer> counts = personJourneyInfoService.queryAgeRangeCounts(ageRanges);
			return ResponseVO.success(counts);
		} catch (Exception e) {
			return ResponseVO.fail(500, "查询年龄统计失败：" + e.getMessage());
		}
	}
	
	/**
	 * 获取查询条件选项接口
	 */
	@PostMapping("/getQueryOptions")
	public ResponseVO<Map<String, List<String>>> getQueryOptions() {
		try {
			Map<String, List<String>> options = personJourneyInfoService.getQueryOptions();
			return ResponseVO.success(options);
		} catch (Exception e) {
			return ResponseVO.fail(500, "获取查询选项失败：" + e.getMessage());
		}
	}
	
	/**
	 * 保存查询条件
	 */
	@PostMapping("/saveQueryCondition")
	public ResponseVO<SavedQueryCondition> saveQueryCondition(@RequestBody Map<String, Object> request) {
		try {
			String queryName = (String) request.get("queryName");
			String queryType = (String) request.get("queryType");
			@SuppressWarnings("unchecked")
			List<Map<String, Integer>> queryRanges = (List<Map<String, Integer>>) request.get("queryRanges");
			
			if (queryName == null || queryName.trim().isEmpty()) {
				return ResponseVO.fail(400, "查询条件名称不能为空");
			}
			if (queryType == null || !java.util.Arrays.asList("age", "mileage", "time").contains(queryType)) {
				return ResponseVO.fail(400, "查询类型无效");
			}
			if (queryRanges == null || queryRanges.isEmpty()) {
				return ResponseVO.fail(400, "查询区间不能为空");
			}
			
			return savedQueryConditionService.saveQueryCondition(queryName, queryType, queryRanges);
		} catch (Exception e) {
			return ResponseVO.fail(500, "保存查询条件失败：" + e.getMessage());
		}
	}
	
	/**
	 * 获取用户的所有查询条件
	 */
	@GetMapping("/getQueryConditions")
	public ResponseVO<List<SavedQueryCondition>> getQueryConditions(@RequestParam(defaultValue = "default_user") String userId) {
		return savedQueryConditionService.getQueryConditionsByUserId(userId);
	}
	
	/**
	 * 根据ID删除查询条件
	 */
	@DeleteMapping("/deleteQueryCondition/{id}")
	public ResponseVO<Boolean> deleteQueryCondition(@PathVariable Long id) {
		return savedQueryConditionService.deleteQueryConditionById(id);
	}
	
	/**
	 * 根据ID获取查询条件
	 */
	@GetMapping("/getQueryCondition/{id}")
	public ResponseVO<SavedQueryCondition> getQueryCondition(@PathVariable Long id) {
		return savedQueryConditionService.getQueryConditionById(id);
	}
}

