<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>人员旅行信息</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <!-- 使用国内可访问的CDN -->
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/layui/2.8.18/css/layui.min.css" media="all">
    <script src="https://cdn.bootcdn.net/ajax/libs/layui/2.8.18/layui.min.js"></script>
    <script src="https://cdn.bootcdn.net/ajax/libs/echarts/5.4.3/echarts.min.js"></script>
    <style>
        body { padding: 20px; font-family: "Microsoft YaHei", Arial, sans-serif; }
        .layui-card { margin-bottom: 20px; }
        #ageChart { width: 100%; height: 400px; }
        .query-form { margin-bottom: 20px; }
        .layui-form-label { width: 80px; }
        .layui-input-inline { width: 120px; }
    </style>
</head>
<body>

<!-- 查询条件表单 -->
<div class="layui-card">
    <div class="layui-card-header">查询条件</div>
    <div class="layui-card-body">
        <form class="layui-form query-form" lay-filter="queryForm">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">年龄范围</label>
                    <div class="layui-input-inline">
                        <input type="number" name="age1" placeholder="最小年龄" autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-form-mid">-</div>
                    <div class="layui-input-inline">
                        <input type="number" name="age2" placeholder="最大年龄" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">旅行里程</label>
                    <div class="layui-input-inline">
                        <input type="number" name="mileAge1" placeholder="最小里程" autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-form-mid">-</div>
                    <div class="layui-input-inline">
                        <input type="number" name="mileAge2" placeholder="最大里程" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">旅行时间</label>
                    <div class="layui-input-inline">
                        <input type="number" name="journeyTime1" placeholder="最小时间" autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-form-mid">-</div>
                    <div class="layui-input-inline">
                        <input type="number" name="journeyTime2" placeholder="最大时间" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" lay-submit lay-filter="queryData">查询数据</button>
                    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="layui-card">
    <div class="layui-card-header">人员旅行信息列表</div>
    <div class="layui-card-body">
        <table class="layui-hide" id="personJourneyTable" lay-filter="personJourneyTable"></table>
    </div>
</div>

<div class="layui-card">
    <div class="layui-card-header">年龄区间段统计</div>
    <div class="layui-card-body">
        <form class="layui-form" lay-filter="ageRangeForm">
            <div class="layui-form-item">
                <label class="layui-form-label">年龄区间</label>
                <div class="layui-input-block">
                    <div id="ageRangesContainer"></div>
                    <button type="button" class="layui-btn layui-btn-sm layui-btn-normal" id="addAgeRangeBtn">添加区间</button>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" lay-submit lay-filter="queryAgeChart">查询图表</button>
                </div>
            </div>
        </form>
        <div id="ageChart"></div>
    </div>
</div>

<script>
    // 等待页面和资源加载完成
    document.addEventListener('DOMContentLoaded', function() {
        // 检查依赖是否加载成功
        if (typeof layui === 'undefined') {
            console.error('Layui 未加载成功');
            document.body.innerHTML = '<div style="text-align:center;padding:50px;color:red;">页面加载失败：Layui框架未加载成功，请检查网络连接</div>';
            return;
        }
        
        if (typeof echarts === 'undefined') {
            console.error('ECharts 未加载成功');
            document.body.innerHTML = '<div style="text-align:center;padding:50px;color:red;">页面加载失败：ECharts图表库未加载成功，请检查网络连接</div>';
            return;
        }

        layui.use(['table', 'layer', 'form'], function () {
            var table = layui.table;
            var layer = layui.layer;
            var form = layui.form;

            // 初始化表格
            var tableIns = table.render({
                elem: '#personJourneyTable'
                , url: '/personJourneyInfo/queryByPage'
                , method: 'post'
                , contentType: 'application/json'
                , parseData: function (res) {
                    return {
                        "code": res.code === 200 ? 0 : res.code,
                        "msg": res.message,
                        "count": res.data ? res.data.total : 0,
                        "data": res.data ? res.data.records : []
                    };
                }
                , request: {
                    pageName: 'page'
                    , limitName: 'size'
                }
                , cols: [[
                    {field: 'personId', title: '人员ID', width: 100, sort: true}
                    , {field: 'birthYear', title: '出生年份', width: 120, sort: true}
                    , {field: 'gender', title: '性别', width: 80, templet: function(d){
                        return d.gender == 1 ? '男' : '女';
                    }}
                    , {field: 'totalJourneyTime', title: '总旅行时间(小时)', width: 150, sort: true}
                    , {field: 'totalMileage', title: '总旅行里程(公里)', width: 150, sort: true}
                ]]
                , page: true
                , limit: 20
                , limits: [10, 20, 30, 40, 50]
                , height: 400
            });

            // 查询表单提交
            form.on('submit(queryData)', function(data) {
                var formData = data.field;
                
                // 构建查询参数
                var queryParams = {
                    page: 1,
                    size: 20,
                    age1: parseInt(formData.age1) || 0,
                    age2: parseInt(formData.age2) || 0,
                    mileAge1: parseInt(formData.mileAge1) || 0,
                    mileAge2: parseInt(formData.mileAge2) || 0,
                    journeyTime1: parseInt(formData.journeyTime1) || 0,
                    journeyTime2: parseInt(formData.journeyTime2) || 0
                };
                
                // 重新加载表格数据
                tableIns.reload({
                    where: queryParams,
                    page: {curr: 1}
                });
                
                return false;
            });

            // Echarts图表初始化
            var myChart = echarts.init(document.getElementById('ageChart'));
            var ageRangeIndex = 0;

            function addAgeRangeInput(min = '', max = '') {
                var container = document.getElementById('ageRangesContainer');
                var div = document.createElement('div');
                div.className = 'layui-input-inline';
                div.style.marginBottom = '10px';
                div.innerHTML = `
                    <input type="number" name="minAge_${ageRangeIndex}" placeholder="最小年龄" autocomplete="off" class="layui-input" value="${min}" style="width: 100px;">
                    <span style="padding: 0 5px;">-</span>
                    <input type="number" name="maxAge_${ageRangeIndex}" placeholder="最大年龄" autocomplete="off" class="layui-input" value="${max}" style="width: 100px;">
                    <button type="button" class="layui-btn layui-btn-danger layui-btn-sm removeAgeRangeBtn">删除</button>
                `;
                container.appendChild(div);
                ageRangeIndex++;
            }

            // 添加初始年龄区间
            addAgeRangeInput(0, 18);
            addAgeRangeInput(19, 30);
            addAgeRangeInput(31, 50);
            addAgeRangeInput(51, 100);

            // 添加年龄区间按钮
            document.getElementById('addAgeRangeBtn').addEventListener('click', function() {
                addAgeRangeInput();
            });

            // 删除年龄区间按钮
            document.getElementById('ageRangesContainer').addEventListener('click', function(e) {
                if (e.target.classList.contains('removeAgeRangeBtn')) {
                    e.target.closest('.layui-input-inline').remove();
                }
            });

            // 查询年龄统计图表
            form.on('submit(queryAgeChart)', function (data) {
                var ageRanges = [];
                var inputs = document.querySelectorAll('#ageRangesContainer input[type="number"]');
                
                for (var i = 0; i < inputs.length; i += 2) {
                    var minAge = inputs[i].value;
                    var maxAge = inputs[i + 1].value;
                    if (minAge !== '' && maxAge !== '') {
                        ageRanges.push({ 
                            minAge: parseInt(minAge), 
                            maxAge: parseInt(maxAge) 
                        });
                    }
                }

                if (ageRanges.length === 0) {
                    layer.msg('请至少添加一个年龄区间');
                    return false;
                }

                // 调用后端接口获取年龄统计数据
                layui.$.ajax({
                    url: '/personJourneyInfo/queryAgeRangeCounts',
                    type: 'post',
                    contentType: 'application/json',
                    data: JSON.stringify(ageRanges),
                    dataType: 'json',
                    success: function (res) {
                        if (res.code === 200) {
                            var categories = ageRanges.map(range => `${range.minAge}-${range.maxAge}岁`);
                            updateChart(categories, res.data);
                            layer.msg('图表数据更新成功');
                        } else {
                            layer.msg('获取图表数据失败：' + res.message);
                        }
                    },
                    error: function (xhr, status, error) {
                        layer.msg('请求图表数据失败：' + error);
                        console.error('Error:', error);
                    }
                });

                return false;
            });

            function updateChart(categories, data) {
                var option = {
                    title: {
                        text: '不同年龄区间旅行记录统计',
                        left: 'center'
                    },
                    tooltip: {
                        trigger: 'axis',
                        axisPointer: {
                            type: 'shadow'
                        }
                    },
                    legend: {
                        data: ['记录总数'],
                        top: 30
                    },
                    xAxis: {
                        type: 'category',
                        data: categories,
                        axisLabel: {
                            rotate: 45
                        }
                    },
                    yAxis: {
                        type: 'value',
                        name: '记录数量'
                    },
                    series: [{
                        name: '记录总数',
                        type: 'bar',
                        data: data,
                        itemStyle: {
                            color: '#1E9FFF'
                        }
                    }]
                };
                myChart.setOption(option);
            }

            // 页面加载完成后初始化图表
            setTimeout(function() {
                // 触发一次年龄统计查询，显示初始图表
                form.on('submit(queryAgeChart)', function(data){ return false; }).call(this, {field: form.val('ageRangeForm')});
            }, 1000);
        });
    });
</script>

</body>
</html> 