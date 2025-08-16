
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>人员旅行信息</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="https://www.layui.com/layui/css/layui.css" media="all">
    <script src="https://www.layui.com/layui/layui.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.3.0/dist/echarts.min.js"></script>
    <style>
        body { padding: 20px; }
        .layui-card { margin-bottom: 20px; }
        #ageChart { width: 100%; height: 400px; }
    </style>
</head>
<body>

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
    layui.use(['table', 'layer', 'form'], function () {
        var table = layui.table;
        var layer = layui.layer;
        var form = layui.form;

        // Layui Table Render
        table.render({
            elem: '#personJourneyTable'
            , url: '/personJourneyInfo/queryByPage' // Data interface
            , method: 'post'
            , contentType: 'application/json'
            , parseData: function (res) { // Modify response data format
                return {
                    "code": res.code === 200 ? 0 : res.code, // Parse Layui's required status code
                    "msg": res.message,
                    "count": res.data ? res.data.total : 0, // Total records
                    "data": res.data ? res.data.records : [] // Data list
                };
            }
            , request: {
                pageName: 'page' // Page field name for backend
                , limitName: 'size' // Size field name for backend
            }
            , where: { // Initial query parameters
                // You can add default query parameters here, e.g.,
                // name: '张三'
            }
            , cols: [[ // Table header
                {field: 'id', title: 'ID', width: 80, sort: true}
                , {field: 'name', title: '姓名'}
                , {field: 'gender', title: '性别'}
                , {field: 'age', title: '年龄', sort: true}
                , {field: 'destination', title: '目的地'}
                , {field: 'travelDate', title: '旅行日期', sort: true}
                // Add more fields as per your PersonJourneyInfo entity
            ]]
            , page: true // Enable pagination
            , limit: 20 // Max records per page
            , limits: [10, 20, 30, 40, 50] // Options for records per page
        });

        // Echarts Render
        var myChart = echarts.init(document.getElementById('ageChart'));

        var ageRangeIndex = 0;

        function addAgeRangeInput(min = '', max = '') {
            var container = document.getElementById('ageRangesContainer');
            var div = document.createElement('div');
            div.className = 'layui-input-inline';
            div.innerHTML = `
                <input type="number" name="minAge_${ageRangeIndex}" placeholder="最小年龄" autocomplete="off" class="layui-input" value="${min}">
                <span style="padding: 0 5px;">-</span>
                <input type="number" name="maxAge_${ageRangeIndex}" placeholder="最大年龄" autocomplete="off" class="layui-input" value="${max}">
                <button type="button" class="layui-btn layui-btn-danger layui-btn-sm removeAgeRangeBtn">删除</button>
            `;
            container.appendChild(div);
            ageRangeIndex++;
        }

        // Add initial age range input
        addAgeRangeInput(0, 18);
        addAgeRangeInput(19, 30);
        addAgeRangeInput(31, 50);
        addAgeRangeInput(51, 100);

        document.getElementById('addAgeRangeBtn').addEventListener('click', function() {
            addAgeRangeInput();
        });

        document.getElementById('ageRangesContainer').addEventListener('click', function(e) {
            if (e.target.classList.contains('removeAgeRangeBtn')) {
                e.target.closest('.layui-input-inline').remove();
            }
        });

        form.on('submit(queryAgeChart)', function (data) {
            var ageRanges = [];
            for (var i = 0; i < ageRangeIndex; i++) {
                var minAge = data.field[`minAge_${i}`];
                var maxAge = data.field[`maxAge_${i}`];
                if (minAge !== undefined && maxAge !== undefined && minAge !== '' && maxAge !== '') {
                    ageRanges.push({ minAge: parseInt(minAge), maxAge: parseInt(maxAge) });
                }
            }

            if (ageRanges.length === 0) {
                layer.msg('请至少添加一个年龄区间');
                return false;
            }

            // --- IMPORTANT: You need to implement the backend API for this part ---
            // Expected backend endpoint: /personJourneyInfo/queryAgeRangeCounts
            // Expected request body: JSON array like: [
            //  { "minAge": 0, "maxAge": 18 },
            //  { "minAge": 19, "maxAge": 30 }
            // ]
            // Expected response: JSON object like: {"code": 200, "message": "success", "data": [120, 300]}

            // For demonstration, using dummy data. Replace with actual AJAX call.
            var dummyData = [];
            var categories = [];
            ageRanges.forEach(function(range) {
                categories.push(`${range.minAge}-${range.maxAge}岁`);
                dummyData.push(Math.floor(Math.random() * 500) + 50); // Random count for demonstration
            });
            updateChart(categories, dummyData);

            /*
            // Uncomment and modify this section to integrate with your backend API
            $.ajax({
                url: '/personJourneyInfo/queryAgeRangeCounts',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(ageRanges),
                dataType: 'json',
                success: function (res) {
                    if (res.code === 200) {
                        var categories = ageRanges.map(range => `${range.minAge}-${range.maxAge}岁`);
                        updateChart(categories, res.data);
                    } else {
                        layer.msg('获取图表数据失败：' + res.message);
                    }
                },
                error: function (xhr, status, error) {
                    layer.msg('请求图表数据失败：' + error);
                }
            });
            */

            return false; // Prevent default form submission
        });

        function updateChart(categories, data) {
            var option = {
                title: {
                    text: '不同年龄区间旅行记录统计'
                },
                tooltip: {},
                legend: {
                    data: ['记录总数']
                },
                xAxis: {
                    data: categories
                },
                yAxis: {},
                series: [{
                    name: '记录总数',
                    type: 'bar',
                    data: data
                }]
            };
            myChart.setOption(option);
        }

        // Initial chart render with dummy data
        form.on('submit(queryAgeChart)', function(data){ return false; }).call(this, {field: form.val('ageRangeForm')});


    });
</script>

</body>
</html> 