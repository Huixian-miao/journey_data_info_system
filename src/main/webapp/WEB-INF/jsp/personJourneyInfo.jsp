<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>人员旅行信息查询系统</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/layui/2.8.18/css/layui.min.css" media="all">
    <script src="https://cdn.bootcdn.net/ajax/libs/layui/2.8.18/layui.min.js"></script>
    <script src="https://cdn.bootcdn.net/ajax/libs/echarts/5.4.3/echarts.min.js"></script>
    <style>
        body { 
            padding: 15px; 
            font-family: "Microsoft YaHei", Arial, sans-serif; 
            background-color: #f5f5f5;
        }
        .layui-card { 
            margin-bottom: 15px; 
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .layui-card-header { 
            background-color: #1E9FFF; 
            color: white; 
            font-weight: bold;
            padding: 10px 15px;
        }
        .chart-container { 
            width: 100%; 
            height: 400px; 
            margin: 15px 0;
            position: relative;
        }
        .query-section {
            margin-bottom: 20px;
            padding: 15px;
            background-color: white;
            border-radius: 5px;
            border-left: 4px solid #1E9FFF;
        }
        .range-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 5px;
            border: 1px solid #e9ecef;
        }
        .range-inputs {
            display: flex;
            align-items: center;
            margin-right: 10px;
            flex: 1;
        }
        .range-inputs input {
            width: 80px;
            margin: 0 5px;
        }
        .range-label {
            font-weight: bold;
            color: #1E9FFF;
            margin-right: 8px;
            min-width: 70px;
        }
        .query-type-selector {
            margin-bottom: 15px;
            text-align: center;
        }
        .query-type-selector .layui-btn {
            margin: 0 8px;
            padding: 6px 15px;
            font-size: 13px;
        }
        .query-type-selector .layui-btn-primary.active {
            background-color: #1E9FFF;
            color: white;
        }
        .result-section {
            margin-top: 20px;
        }
        .chart-section {
            margin-top: 20px;
            background-color: white;
            padding: 15px;
            border-radius: 5px;
            min-height: 500px;
            width: 100%;
        }
        .chart-tabs {
            margin-bottom: 15px;
            width: 100%;
        }
        .chart-tabs .layui-tab-title li {
            font-size: 14px;
            padding: 8px 15px;
        }
        .layui-tab-content {
            min-height: 450px;
            width: 100%;
        }
        .layui-tab-item {
            height: 450px;
            overflow: hidden;
            width: 100%;
        }
        .layui-tab-item .chart-container {
            height: 420px;
            margin: 10px 0;
            width: 100%;
        }
        .layui-tab {
            width: 100%;
        }
        .history-section {
            margin-top: 15px;
            padding: 10px;
            background-color: #f0f9ff;
            border-radius: 5px;
            border: 1px solid #b3d8ff;
        }
        .history-item {
            display: inline-block;
            margin: 5px;
            padding: 5px 10px;
            background-color: #e6f3ff;
            border: 1px solid #91d5ff;
            border-radius: 3px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s ease;
        }
        .history-item:hover {
            background-color: #b3d8ff;
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .history-item.active {
            background-color: #1E9FFF;
            color: white;
            border-color: #1E9FFF;
        }
        .history-item .query-info {
            font-size: 10px;
            color: #666;
            margin-top: 2px;
        }
        .history-item.active .query-info {
            color: #e6f3ff;
        }
        .save-query-section {
            margin-top: 10px;
            padding: 8px;
            background-color: #f6ffed;
            border-radius: 3px;
            border: 1px solid #b7eb8f;
        }
    </style>
</head>
<body>

<!-- 查询条件区域 -->
<div class="layui-card">
    <div class="layui-card-header">查询条件设置</div>
    <div class="layui-card-body">
        
        <!-- 查询类型选择器 -->
        <div class="query-type-selector">
            <button type="button" class="layui-btn layui-btn-primary active" data-type="age">
                📊 按年龄查询
            </button>
            <button type="button" class="layui-btn layui-btn-primary" data-type="mileage">
                ✈️ 按飞行里程查询
            </button>
            <button type="button" class="layui-btn layui-btn-primary" data-type="time">
                ⏰ 按飞行时间查询
            </button>
        </div>
        
        <!-- 动态查询表单 -->
        <div class="query-section">
            <h3 id="queryTitle" style="color: #1E9FFF; margin-bottom: 10px; font-size: 16px;">📊 按年龄查询</h3>
            <form class="layui-form" lay-filter="queryForm">
                <div class="layui-form-item">
                    <label class="layui-form-label">查询区间</label>
                    <div class="layui-input-block">
                        <div id="rangesContainer">
                            <!-- 区间输入框将在这里动态生成 -->
                        </div>
                        <button type="button" class="layui-btn layui-btn-sm layui-btn-normal" id="addRangeBtn">
                            <i class="layui-icon layui-icon-add-1"></i> 添加区间
                        </button>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button class="layui-btn" lay-submit lay-filter="queryData">
                            <i class="layui-icon layui-icon-search"></i> 查询数据
                        </button>
                        <button type="button" class="layui-btn layui-btn-primary" id="clearBtn">
                            <i class="layui-icon layui-icon-refresh"></i> 清空条件
                        </button>
                    </div>
                </div>
            </form>
            
            <!-- 历史查询条件保存区域 -->
            <div class="save-query-section">
                <div class="layui-form-item">
                    <label class="layui-form-label">保存查询</label>
                    <div class="layui-input-inline" style="width: 200px;">
                        <input type="text" id="queryName" placeholder="输入查询条件名称" class="layui-input">
                    </div>
                    <button type="button" class="layui-btn layui-btn-sm" id="saveQueryBtn">
                        <i class="layui-icon layui-icon-save"></i> 保存
                    </button>
                </div>
                <div style="margin-top: 5px; font-size: 11px; color: #52c41a; line-height: 1.3;">
                    💾 保存当前查询条件，方便下次快速使用
                </div>
            </div>
            
            <!-- 历史查询条件选择区域 -->
            <div class="history-section" id="historySection" style="display: none;">
                <div style="margin-bottom: 8px; font-weight: bold; color: #1E9FFF;">
                    📚 历史查询条件：
                    <span style="font-size: 12px; font-weight: normal; color: #666; margin-left: 10px;">
                        💡 点击任意历史条件可自动应用并执行查询
                    </span>
                </div>
                <div id="historyContainer">
                    <!-- 历史查询条件将在这里动态生成 -->
                </div>
                <div style="margin-top: 8px; font-size: 11px; color: #999; line-height: 1.4;">
                    <strong>使用说明：</strong><br>
                    1. 点击历史条件名称可自动应用查询条件并执行查询<br>
                    2. 点击 × 按钮可删除不需要的历史条件<br>
                    3. 历史条件按最近使用时间排序，最新的显示在前面
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 查询结果展示区域 -->
<div class="layui-card result-section" id="resultSection" style="display: none;">
    <div class="layui-card-header">查询结果</div>
    <div class="layui-card-body">
        
        <!-- 数据列表 -->
        <div class="layui-card">
            <div class="layui-card-header">📋 数据列表</div>
            <div class="layui-card-body">
                <table class="layui-hide" id="resultTable" lay-filter="resultTable"></table>
            </div>
        </div>
        
        <!-- 图表展示区域 -->
        <div class="chart-section" id="chartSection" style="display: none;">
            <div class="layui-card-header">📊 图表展示</div>
            <div class="layui-card-body">
                <!-- 图表切换标签 -->
                <div class="chart-tabs">
                    <div class="layui-tab layui-tab-brief" lay-filter="chartTabs">
                        <ul class="layui-tab-title">
                            <li class="layui-this" lay-id="barChart">📊 柱状图</li>
                            <li lay-id="pieChart">🥧 饼状图</li>
                            <li lay-id="lineChart">📈 折线图</li>
                        </ul>
                        <div class="layui-tab-content">
                            <!-- 柱状图 -->
                            <div class="layui-tab-item layui-show">
                                <div id="barChart" class="chart-container"></div>
                            </div>
                            
                            <!-- 饼状图 -->
                            <div class="layui-tab-item">
                                <div id="pieChart" class="chart-container"></div>
                            </div>
                            
                            <!-- 折线图 -->
                            <div class="layui-tab-item">
                                <div id="lineChart" class="chart-container"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
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

        layui.use(['table', 'layer', 'form', 'element'], function () {
            var table = layui.table;
            var layer = layui.layer;
            var form = layui.form;
            var element = layui.element;

            // 全局变量
            var currentQueryType = 'age';
            var currentQueryData = [];
            var currentQueryRanges = [];
            var rangeIndex = 0;
            var savedQueries = JSON.parse(localStorage.getItem('savedQueries') || '{}');
            
            // 图表实例存储
            var chartInstances = {
                barChart: null,
                pieChart: null,
                lineChart: null
            };
            
            // 窗口大小变化时重绘图表
            window.addEventListener('resize', function() {
                Object.values(chartInstances).forEach(function(chart) {
                    if (chart) {
                        chart.resize();
                    }
                });
            });

            // 初始化表格
            var tableIns = table.render({
                elem: '#resultTable'
                , cols: [[
                    {field: 'personId', title: '人员ID', width: 100, sort: true}
                    , {field: 'birthYear', title: '出生年份', width: 120, sort: true}
                    , {field: 'age', title: '年龄', width: 80, templet: function(d){
                        return new Date().getFullYear() - d.birthYear;
                    }}
                    , {field: 'gender', title: '性别', width: 80, templet: function(d){
                        return d.gender == 1 ? '男' : '女';
                    }}
                    , {field: 'totalJourneyTime', title: '总旅行时间(小时)', width: 150, sort: true}
                    , {field: 'totalMileage', title: '总旅行里程(公里)', width: 150, sort: true}
                ]]
                , page: true
                , limit: 20
                , limits: [10, 15, 20]
                , height: 400
                , text: {
                    none: '暂无数据，请先设置查询条件进行查询'
                }
            });

            // 查询类型切换
            document.querySelectorAll('.query-type-selector .layui-btn').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    document.querySelectorAll('.query-type-selector .layui-btn').forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                    
                    currentQueryType = this.getAttribute('data-type');
                    updateQueryTitle();
                    clearRanges();
                    initRanges();
                    hideResults();
                });
            });

            // 更新查询标题
            function updateQueryTitle() {
                var titles = {
                    'age': '📊 按年龄查询',
                    'mileage': '✈️ 按飞行里程查询',
                    'time': '⏰ 按飞行时间查询'
                };
                document.getElementById('queryTitle').textContent = titles[currentQueryType];
            }

            // 初始化区间 - 默认设置为两个区间
            function initRanges() {
                var ranges = {
                    'age': [{min: 0, max: 30}, {min: 31, max: 100}],
                    'mileage': [{min: 0, max: 500}, {min: 501, max: 5000}],
                    'time': [{min: 0, max: 20}, {min: 21, max: 100}]
                };
                
                ranges[currentQueryType].forEach(function(range) {
                    addRangeInput(range.min, range.max);
                });
            }

            // 添加区间输入框
            function addRangeInput(min = '', max = '') {
                var container = document.getElementById('rangesContainer');
                var div = document.createElement('div');
                div.className = 'range-item';
                div.setAttribute('data-index', rangeIndex);
                
                var labels = {
                    'age': '年龄区间',
                    'mileage': '里程区间',
                    'time': '时间区间'
                };
                
                var units = {
                    'age': '岁',
                    'mileage': '公里',
                    'time': '小时'
                };
                
                div.innerHTML = `
                    <div class="range-label">${labels[currentQueryType]}</div>
                    <div class="range-inputs">
                        <input type="number" placeholder="最小值" autocomplete="off" class="layui-input" value="${min}">
                        <span style="padding: 0 5px; color: #666;">-</span>
                        <input type="number" placeholder="最大值" autocomplete="off" class="layui-input" value="${max}">
                        <span style="margin-left: 5px; color: #999;">${units[currentQueryType]}</span>
                    </div>
                    <button type="button" class="layui-btn layui-btn-danger layui-btn-sm removeRangeBtn">删除</button>
                `;
                container.appendChild(div);
                rangeIndex++;
            }

            // 清空区间
            function clearRanges() {
                document.getElementById('rangesContainer').innerHTML = '';
                rangeIndex = 0;
            }

            // 绑定按钮事件
            document.getElementById('addRangeBtn').addEventListener('click', function() {
                addRangeInput();
            });

            document.getElementById('clearBtn').addEventListener('click', function() {
                clearRanges();
                initRanges();
                hideResults();
            });

            // 保存查询条件
            document.getElementById('saveQueryBtn').addEventListener('click', function() {
                var queryName = document.getElementById('queryName').value.trim();
                if (!queryName) {
                    layer.msg('请输入查询条件名称');
                    return;
                }
                
                var ranges = getRanges();
                if (ranges.length === 0) {
                    layer.msg('请先设置查询条件');
                    return;
                }
                
                var queryKey = currentQueryType + '_' + Date.now();
                savedQueries[queryKey] = {
                    name: queryName,
                    type: currentQueryType,
                    ranges: ranges,
                    timestamp: Date.now()
                };
                
                localStorage.setItem('savedQueries', JSON.stringify(savedQueries));
                document.getElementById('queryName').value = '';
                updateHistoryDisplay();
                layer.msg('查询条件保存成功');
            });

            document.addEventListener('click', function(e) {
                if (e.target.classList.contains('removeRangeBtn')) {
                    e.target.closest('.range-item').remove();
                }
            });

            // 查询表单提交
            form.on('submit(queryData)', function(data) {
                var ranges = getRanges();
                if (ranges.length === 0) {
                    layer.msg('请至少添加一个查询区间');
                    return false;
                }
                
                if (currentQueryType === 'time' && checkTimeRangeOverlap(ranges)) {
                    layer.msg('时间区间不允许重叠，请重新设置');
                    return false;
                }
                
                queryData(currentQueryType, ranges);
                return false;
            });

            // 获取区间数据
            function getRanges() {
                var ranges = [];
                var inputs = document.querySelectorAll('#rangesContainer input[type="number"]');
                console.log('找到输入框数量:', inputs.length);
                
                for (var i = 0; i < inputs.length; i += 2) {
                    var min = inputs[i].value;
                    var max = inputs[i + 1].value;
                    console.log(`区间 ${i/2 + 1}: min=${min}, max=${max}`);
                    
                    if (min !== '' && max !== '') {
                        var minNum = parseInt(min);
                        var maxNum = parseInt(max);
                        
                        if (minNum <= maxNum) {
                            ranges.push({ min: minNum, max: maxNum });
                        } else {
                            console.warn(`区间 ${i/2 + 1} 的最小值大于最大值: ${minNum} > ${maxNum}`);
                        }
                    }
                }
                
                console.log('生成的区间数据:', ranges);
                return ranges;
            }

            // 检查时间区间重叠
            function checkTimeRangeOverlap(ranges) {
                for (var i = 0; i < ranges.length; i++) {
                    for (var j = i + 1; j < ranges.length; j++) {
                        if (ranges[i].max > ranges[j].min && ranges[i].min < ranges[j].max) {
                            return true;
                        }
                    }
                }
                return false;
            }

            // 查询数据
            function queryData(type, ranges) {
                var url = '';
                var requestData = {};
                
                switch(type) {
                    case 'age':
                        url = '/personJourneyInfo/queryByAgeRanges';
                        requestData = { ageRanges: ranges };
                        break;
                    case 'mileage':
                        url = '/personJourneyInfo/queryByMileageRanges';
                        requestData = { mileageRanges: ranges };
                        break;
                    case 'time':
                        url = '/personJourneyInfo/queryByTimeRanges';
                        requestData = { timeRanges: ranges };
                        break;
                }

                layer.load(1, {shade: [0.3, '#000']});

                layui.$.ajax({
                    url: url,
                    type: 'post',
                    contentType: 'application/json',
                    data: JSON.stringify(requestData),
                    dataType: 'json',
                    success: function (res) {
                        layer.closeAll('loading');
                        if (res.code === 200) {
                            currentQueryData = res.data;
                            currentQueryRanges = ranges;
                            updateTable(res.data);
                            updateCharts(type, ranges, res.data);
                            showResults();
                            layer.msg('查询成功，共找到 ' + res.data.length + ' 条记录');
                        } else {
                            layer.msg('查询失败：' + res.message);
                        }
                    },
                    error: function (xhr, status, error) {
                        layer.closeAll('loading');
                        layer.msg('查询失败：' + error);
                        console.error('Error:', error);
                    }
                });
            }

            // 显示/隐藏结果区域
            function showResults() {
                document.getElementById('resultSection').style.display = 'block';
                if (currentQueryData.length > 0) {
                    document.getElementById('chartSection').style.display = 'block';
                }
            }

            function hideResults() {
                document.getElementById('resultSection').style.display = 'none';
                document.getElementById('chartSection').style.display = 'none';
            }

            // 更新表格
            function updateTable(data) {
                tableIns.reload({
                    data: data,
                    page: {curr: 1}
                });
            }

            // 强制重绘所有图表
            function forceResizeCharts() {
                setTimeout(function() {
                    Object.values(chartInstances).forEach(function(chart) {
                        if (chart) {
                            chart.resize();
                        }
                    });
                }, 100);
            }
            
            // 更新图表
            function updateCharts(type, ranges, data) {
                if (data.length === 0) return;
                
                // 确保图表容器存在且可见
                var chartSection = document.getElementById('chartSection');
                if (chartSection.style.display === 'none') {
                    chartSection.style.display = 'block';
                }
                
                // 延迟初始化图表，确保DOM完全渲染
                setTimeout(function() {
                    switch(type) {
                        case 'age':
                            updateAgeCharts(ranges, data);
                            break;
                        case 'mileage':
                            updateMileageCharts(ranges, data);
                            break;
                        case 'time':
                            updateTimeCharts(ranges, data);
                            break;
                    }
                    
                    // 强制重绘图表
                    forceResizeCharts();
                }, 100);
            }

            // 更新年龄相关图表
            function updateAgeCharts(ranges, data) {
                console.log('更新年龄图表 - ranges:', ranges, 'data:', data);
                
                // 确保ranges数据正确
                if (!ranges || ranges.length === 0) {
                    console.error('年龄区间数据为空');
                    return;
                }
                
                // 验证ranges数据格式
                var validRanges = ranges.filter(range => {
                    return range && typeof range.min === 'number' && typeof range.max === 'number';
                });
                
                if (validRanges.length === 0) {
                    console.error('没有有效的年龄区间数据');
                    return;
                }
                
                var categories = validRanges.map(range => {
                    return `${range.min}-${range.max}岁`;
                });
                
                var counts = validRanges.map(range => {
                    var currentYear = new Date().getFullYear();
                    return data.filter(item => {
                        var age = currentYear - item.birthYear;
                        return age >= range.min && age <= range.max;
                    }).length;
                });
                
                console.log('生成的categories:', categories, 'counts:', counts);

                // 检查并初始化柱状图
                var barContainer = document.getElementById('barChart');
                if (!barContainer) {
                    console.error('柱状图容器不存在');
                    return;
                }
                
                // 柱状图
                var barChart = echarts.init(barContainer);
                var barOption = {
                    title: { 
                        text: '年龄区间统计 - 柱状图', 
                        left: 'center',
                        fontSize: 14
                    },
                    tooltip: { 
                        trigger: 'axis',
                        axisPointer: { type: 'shadow' }
                    },
                    grid: {
                        left: '15%',
                        right: '15%',
                        bottom: '30%',
                        top: '20%'
                    },
                    xAxis: { 
                        type: 'category', 
                        data: categories,
                        axisLabel: { 
                            rotate: 45,
                            fontSize: 12,
                            interval: 0,
                            show: true,
                            color: '#333'
                        },
                        axisTick: {
                            show: true,
                            alignWithLabel: true
                        },
                        axisLine: {
                            show: true
                        }
                    },
                    yAxis: { 
                        type: 'value', 
                        name: '记录数量',
                        axisLabel: {
                            color: '#333'
                        }
                    },
                    series: [{
                        name: '记录数量',
                        type: 'bar',
                        data: counts,
                        itemStyle: { color: '#1E9FFF' },
                        barWidth: '60%'
                    }]
                };
                barChart.setOption(barOption);
                chartInstances.barChart = barChart;

                // 检查并初始化饼状图
                var pieContainer = document.getElementById('pieChart');
                if (!pieContainer) {
                    console.error('饼状图容器不存在');
                    return;
                }
                
                // 饼状图
                var pieChart = echarts.init(pieContainer);
                var pieOption = {
                    title: { 
                        text: '年龄区间统计 - 饼状图', 
                        left: 'center',
                        fontSize: 14
                    },
                    tooltip: { 
                        trigger: 'item',
                        formatter: '{a} <br/>{b}: {c} ({d}%)'
                    },
                    legend: {
                        orient: 'vertical',
                        left: 'left',
                        top: 'middle',
                        fontSize: 12
                    },
                    series: [{
                        name: '记录数量',
                        type: 'pie',
                        radius: ['20%', '50%'],
                        center: ['60%', '50%'],
                        data: categories.map((cat, index) => ({
                            name: cat,
                            value: counts[index]
                        })),
                        emphasis: {
                            itemStyle: {
                                shadowBlur: 10,
                                shadowOffsetX: 0,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                            }
                        },
                        label: {
                            fontSize: 11,
                            formatter: '{b}\n{c}',
                            show: true,
                            color: '#333'
                        },
                        labelLine: {
                            show: true
                        }
                    }]
                };
                pieChart.setOption(pieOption);
                chartInstances.pieChart = pieChart;

                // 检查并初始化折线图
                var lineContainer = document.getElementById('lineChart');
                if (!lineContainer) {
                    console.error('折线图容器不存在');
                    return;
                }
                
                // 折线图
                var lineChart = echarts.init(lineContainer);
                var lineOption = {
                    title: { 
                        text: '年龄区间统计 - 折线图', 
                        left: 'center',
                        fontSize: 14
                    },
                    tooltip: { 
                        trigger: 'axis' 
                    },
                    grid: {
                        left: '15%',
                        right: '15%',
                        bottom: '30%',
                        top: '20%'
                    },
                    xAxis: { 
                        type: 'category', 
                        data: categories,
                        axisLabel: { 
                            rotate: 45,
                            fontSize: 12,
                            interval: 0,
                            show: true,
                            color: '#333'
                        },
                        axisTick: {
                            show: true,
                            alignWithLabel: true
                        },
                        axisLine: {
                            show: true
                        }
                    },
                    yAxis: { 
                        type: 'value', 
                        name: '记录数量',
                        axisLabel: {
                            color: '#333'
                        }
                    },
                    series: [{
                        name: '记录数量',
                        type: 'line',
                        data: counts,
                        itemStyle: { color: '#1E9FFF' },
                        lineStyle: { color: '#1E9FFF', width: 3 },
                        symbol: 'circle',
                        symbolSize: 8
                    }]
                };
                lineChart.setOption(lineOption);
                chartInstances.lineChart = lineChart;
            }

            // 更新里程相关图表
            function updateMileageCharts(ranges, data) {
                console.log('更新里程图表 - ranges:', ranges, 'data:', data);
                
                // 确保ranges数据正确
                if (!ranges || ranges.length === 0) {
                    console.error('里程区间数据为空');
                    return;
                }
                
                // 验证ranges数据格式
                var validRanges = ranges.filter(range => {
                    return range && typeof range.min === 'number' && typeof range.max === 'number';
                });
                
                if (validRanges.length === 0) {
                    console.error('没有有效的里程区间数据');
                    return;
                }
                
                var categories = validRanges.map(range => {
                    return `${range.min}-${range.max}公里`;
                });
                
                var counts = validRanges.map(range => {
                    return data.filter(item => 
                        item.totalMileage >= range.min && item.totalMileage <= range.max
                    ).length;
                });
                
                console.log('生成的categories:', categories, 'counts:', counts);

                // 检查并初始化柱状图
                var barContainer = document.getElementById('barChart');
                if (!barContainer) {
                    console.error('柱状图容器不存在');
                    return;
                }
                
                // 柱状图
                var barChart = echarts.init(barContainer);
                var barOption = {
                    title: { 
                        text: '里程区间统计 - 柱状图', 
                        left: 'center',
                        fontSize: 14
                    },
                    tooltip: { 
                        trigger: 'axis',
                        axisPointer: { type: 'shadow' }
                    },
                    grid: {
                        left: '15%',
                        right: '15%',
                        bottom: '30%',
                        top: '20%'
                    },
                    xAxis: { 
                        type: 'category', 
                        data: categories,
                        axisLabel: { 
                            rotate: 45,
                            fontSize: 12,
                            interval: 0,
                            show: true,
                            color: '#333'
                        },
                        axisTick: {
                            show: true,
                            alignWithLabel: true
                        },
                        axisLine: {
                            show: true
                        }
                    },
                    yAxis: { 
                        type: 'value', 
                        name: '记录数量',
                        axisLabel: {
                            color: '#333'
                        }
                    },
                    series: [{
                        name: '记录数量',
                        type: 'bar',
                        data: counts,
                        itemStyle: { color: '#67C23A' },
                        barWidth: '60%'
                    }]
                };
                barChart.setOption(barOption);
                chartInstances.barChart = barChart;

                // 检查并初始化饼状图
                var pieContainer = document.getElementById('pieChart');
                if (!pieContainer) {
                    console.error('饼状图容器不存在');
                    return;
                }
                
                // 饼状图
                var pieChart = echarts.init(pieContainer);
                var pieOption = {
                    title: { 
                        text: '里程区间统计 - 饼状图', 
                        left: 'center',
                        fontSize: 14
                    },
                    tooltip: { 
                        trigger: 'item',
                        formatter: '{a} <br/>{b}: {c} ({d}%)'
                    },
                    legend: {
                        orient: 'vertical',
                        left: 'left',
                        top: 'middle',
                        fontSize: 12
                    },
                    series: [{
                        name: '记录数量',
                        type: 'pie',
                        radius: ['20%', '50%'],
                        center: ['60%', '50%'],
                        data: categories.map((cat, index) => ({
                            name: cat,
                            value: counts[index]
                        })),
                        emphasis: {
                            itemStyle: {
                                shadowBlur: 10,
                                shadowOffsetX: 0,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                            }
                        },
                        label: {
                            fontSize: 11,
                            formatter: '{b}\n{c}',
                            show: true,
                            color: '#333'
                        },
                        labelLine: {
                            show: true
                        }
                    }]
                };
                pieChart.setOption(pieOption);
                chartInstances.pieChart = pieChart;

                // 检查并初始化折线图
                var lineContainer = document.getElementById('lineChart');
                if (!lineContainer) {
                    console.error('折线图容器不存在');
                    return;
                }
                
                // 折线图
                var lineChart = echarts.init(lineContainer);
                var lineOption = {
                    title: { 
                        text: '里程区间统计 - 折线图', 
                        left: 'center',
                        fontSize: 14
                    },
                    tooltip: { 
                        trigger: 'axis' 
                    },
                    grid: {
                        left: '15%',
                        right: '15%',
                        bottom: '30%',
                        top: '20%'
                    },
                    xAxis: { 
                        type: 'category', 
                        data: categories,
                        axisLabel: { 
                            rotate: 45,
                            fontSize: 12,
                            interval: 0,
                            show: true,
                            color: '#333'
                        },
                        axisTick: {
                            show: true,
                            alignWithLabel: true
                        },
                        axisLine: {
                            show: true
                        }
                    },
                    yAxis: { 
                        type: 'value', 
                        name: '记录数量',
                        axisLabel: {
                            color: '#333'
                        }
                    },
                    series: [{
                        name: '记录数量',
                        type: 'line',
                        data: counts,
                        itemStyle: { color: '#67C23A' },
                        lineStyle: { color: '#67C23A', width: 3 },
                        symbol: 'circle',
                        symbolSize: 8
                    }]
                };
                lineChart.setOption(lineOption);
                chartInstances.lineChart = lineChart;
            }

            // 更新时间相关图表
            function updateTimeCharts(ranges, data) {
                console.log('更新时间图表 - ranges:', ranges, 'data:', data);
                
                // 确保ranges数据正确
                if (!ranges || ranges.length === 0) {
                    console.error('时间区间数据为空');
                    return;
                }
                
                // 验证ranges数据格式
                var validRanges = ranges.filter(range => {
                    return range && typeof range.min === 'number' && typeof range.max === 'number';
                });
                
                if (validRanges.length === 0) {
                    console.error('没有有效的时间区间数据');
                    return;
                }
                
                var categories = validRanges.map(range => {
                    return `${range.min}-${range.max}小时`;
                });
                
                var counts = validRanges.map(range => {
                    return data.filter(item => 
                        item.totalJourneyTime >= range.min && item.totalJourneyTime <= range.max
                    ).length;
                });
                
                console.log('生成的categories:', categories, 'counts:', counts);

                // 检查并初始化柱状图
                var barContainer = document.getElementById('barChart');
                if (!barContainer) {
                    console.error('柱状图容器不存在');
                    return;
                }
                
                // 柱状图
                var barChart = echarts.init(barContainer);
                var barOption = {
                    title: { 
                        text: '时间区间统计 - 柱状图', 
                        left: 'center',
                        fontSize: 14
                    },
                    tooltip: { 
                        trigger: 'axis',
                        axisPointer: { type: 'shadow' }
                    },
                    grid: {
                        left: '15%',
                        right: '15%',
                        bottom: '30%',
                        top: '20%'
                    },
                    xAxis: { 
                        type: 'category', 
                        data: categories,
                        axisLabel: { 
                            rotate: 45,
                            fontSize: 12,
                            interval: 0,
                            show: true,
                            color: '#333'
                        },
                        axisTick: {
                            show: true,
                            alignWithLabel: true
                        },
                        axisLine: {
                            show: true
                        }
                    },
                    yAxis: { 
                        type: 'value', 
                        name: '记录数量',
                        axisLabel: {
                            color: '#333'
                        }
                    },
                    series: [{
                        name: '记录数量',
                        type: 'bar',
                        data: counts,
                        itemStyle: { color: '#E6A23C' },
                        barWidth: '60%'
                    }]
                };
                barChart.setOption(barOption);
                chartInstances.barChart = barChart;

                // 检查并初始化饼状图
                var pieContainer = document.getElementById('pieChart');
                if (!pieContainer) {
                    console.error('饼状图容器不存在');
                    return;
                }
                
                // 饼状图
                var pieChart = echarts.init(pieContainer);
                var pieOption = {
                    title: { 
                        text: '时间区间统计 - 饼状图', 
                        left: 'center',
                        fontSize: 14
                    },
                    tooltip: { 
                        trigger: 'item',
                        formatter: '{a} <br/>{b}: {c} ({d}%)'
                    },
                    legend: {
                        orient: 'vertical',
                        left: 'left',
                        top: 'middle',
                        fontSize: 12
                    },
                    series: [{
                        name: '记录数量',
                        type: 'pie',
                        radius: ['20%', '50%'],
                        center: ['60%', '50%'],
                        data: categories.map((cat, index) => ({
                            name: cat,
                            value: counts[index]
                        })),
                        emphasis: {
                            itemStyle: {
                                shadowBlur: 10,
                                shadowOffsetX: 0,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                            }
                        },
                        label: {
                            fontSize: 11,
                            formatter: '{b}\n{c}',
                            show: true,
                            color: '#333'
                        },
                        labelLine: {
                            show: true
                        }
                    }]
                };
                pieChart.setOption(pieOption);
                chartInstances.pieChart = pieChart;

                // 检查并初始化折线图
                var lineContainer = document.getElementById('lineChart');
                if (!lineContainer) {
                    console.error('折线图容器不存在');
                    return;
                }
                
                // 折线图
                var lineChart = echarts.init(lineContainer);
                var lineOption = {
                    title: { 
                        text: '时间区间统计 - 折线图', 
                        left: 'center',
                        fontSize: 14
                    },
                    tooltip: { 
                        trigger: 'axis' 
                    },
                    grid: {
                        left: '15%',
                        right: '15%',
                        bottom: '30%',
                        top: '20%'
                    },
                    xAxis: { 
                        type: 'category', 
                        data: categories,
                        axisLabel: { 
                            rotate: 45,
                            fontSize: 12,
                            interval: 0,
                            show: true,
                            color: '#333'
                        },
                        axisTick: {
                            show: true,
                            alignWithLabel: true
                        },
                        axisLine: {
                            show: true
                        }
                    },
                    yAxis: { 
                        type: 'value', 
                        name: '记录数量',
                        axisLabel: {
                            color: '#333'
                        }
                    },
                    series: [{
                        name: '记录数量',
                        type: 'line',
                        data: counts,
                        itemStyle: { color: '#E6A23C' },
                        lineStyle: { color: '#E6A23C', width: 3 },
                        symbol: 'circle',
                        symbolSize: 8
                    }]
                };
                lineChart.setOption(lineOption);
                chartInstances.lineChart = lineChart;
            }

            // 更新历史查询条件显示
            function updateHistoryDisplay() {
                var historyContainer = document.getElementById('historyContainer');
                var historySection = document.getElementById('historySection');
                
                if (Object.keys(savedQueries).length === 0) {
                    historySection.style.display = 'none';
                    return;
                }
                
                historySection.style.display = 'block';
                historyContainer.innerHTML = '';
                
                // 按时间排序，最新的在前面
                var sortedKeys = Object.keys(savedQueries).sort(function(a, b) {
                    return savedQueries[b].timestamp - savedQueries[a].timestamp;
                });
                
                sortedKeys.forEach(function(key) {
                    var query = savedQueries[key];
                    var div = document.createElement('div');
                    div.className = 'history-item';
                    div.setAttribute('data-key', key);
                    
                    var typeLabels = {
                        'age': '年龄查询',
                        'mileage': '里程查询',
                        'time': '时间查询'
                    };
                    
                    var rangeText = query.ranges.map(function(range) {
                        var units = {
                            'age': '岁',
                            'mileage': '公里',
                            'time': '小时'
                        };
                        return range.min + '-' + range.max + units[query.type];
                    }).join(', ');
                    
                    div.innerHTML = `
                        <div>${query.name}</div>
                        <div class="query-info">${typeLabels[query.type]} | ${rangeText}</div>
                    `;
                    div.title = '点击应用此查询条件并自动执行查询';
                    
                    // 绑定点击事件
                    div.addEventListener('click', function(e) {
                        if (e.target.tagName !== 'SPAN') { // 避免删除按钮触发
                            applyHistoryQuery(key, query);
                        }
                    });
                    
                    // 添加删除按钮
                    var deleteBtn = document.createElement('span');
                    deleteBtn.innerHTML = ' ×';
                    deleteBtn.style.cssText = 'margin-left: 5px; cursor: pointer; font-weight: bold; color: #999;';
                    deleteBtn.title = '删除此查询条件';
                    deleteBtn.addEventListener('click', function(e) {
                        e.stopPropagation();
                        deleteHistoryQuery(key);
                    });
                    div.appendChild(deleteBtn);
                    
                    historyContainer.appendChild(div);
                });
                
                console.log('历史查询条件已更新，共', sortedKeys.length, '个');
            }
            
            // 应用历史查询条件
            function applyHistoryQuery(key, query) {
                console.log('应用历史查询条件:', key, query);
                
                try {
                    // 切换到对应的查询类型
                    document.querySelectorAll('.query-type-selector .layui-btn').forEach(b => b.classList.remove('active'));
                    var targetBtn = document.querySelector(`[data-type="${query.type}"]`);
                    if (targetBtn) {
                        targetBtn.classList.add('active');
                    } else {
                        console.error('未找到对应的查询类型按钮:', query.type);
                        return;
                    }
                    
                    currentQueryType = query.type;
                    updateQueryTitle();
                    clearRanges();
                    
                    // 应用保存的查询条件
                    if (query.ranges && query.ranges.length > 0) {
                        query.ranges.forEach(function(range) {
                            addRangeInput(range.min, range.max);
                        });
                        console.log('已应用查询区间:', query.ranges);
                    } else {
                        console.error('查询区间数据为空');
                        return;
                    }
                    
                    // 高亮当前选中的历史条件
                    document.querySelectorAll('.history-item').forEach(item => item.classList.remove('active'));
                    var targetItem = document.querySelector(`[data-key="${key}"]`);
                    if (targetItem) {
                        targetItem.classList.add('active');
                    }
                    
                    hideResults();
                    
                    // 自动执行查询
                    setTimeout(function() {
                        console.log('开始执行历史查询...');
                        queryData(currentQueryType, query.ranges);
                    }, 200);
                    
                } catch (error) {
                    console.error('应用历史查询条件时出错:', error);
                    layer.msg('应用历史查询条件失败，请重试');
                }
            }
            
            // 删除历史查询条件
            function deleteHistoryQuery(key) {
                layer.confirm('确定要删除这个查询条件吗？', {
                    icon: 3,
                    title: '确认删除'
                }, function(index) {
                    delete savedQueries[key];
                    localStorage.setItem('savedQueries', JSON.stringify(savedQueries));
                    updateHistoryDisplay();
                    layer.close(index);
                    layer.msg('删除成功');
                });
            }

            // 初始化页面
            initRanges();
            updateHistoryDisplay();
            
            // 监听图表标签页切换，确保图表正确显示
            element.on('tab(chartTabs)', function(data) {
                setTimeout(function() {
                    var activeTabId = data.elem.attr('lay-id');
                    if (chartInstances[activeTabId]) {
                        chartInstances[activeTabId].resize();
                    }
                    // 强制重绘所有图表
                    forceResizeCharts();
                }, 100);
            });
            
            // 显示使用提示
            setTimeout(function() {
                layer.msg('💡 提示：设置查询条件后点击"查询数据"按钮即可查看结果', {
                    icon: 1,
                    time: 5000,
                    offset: 't'
                });
            }, 1000);
            
            // 测试历史查询条件功能
            setTimeout(function() {
                if (Object.keys(savedQueries).length > 0) {
                    console.log('发现保存的查询条件:', savedQueries);
                    layer.msg('📚 发现保存的查询条件，点击可快速应用', {
                        icon: 1,
                        time: 3000,
                        offset: 't'
                    });
                }
            }, 2000);
        });
    });
</script>

</body>
</html> 