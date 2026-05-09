# 脉冲爆震温度畸变装置 - CFD后处理工具

> 基于 MATLAB 的 CFD（计算流体力学）仿真结果后处理系统，专用于脉冲爆震发动机（RDC）温度畸变装置的流场数据分析。

---

## 📁 项目结构

```
matlab/
├── main.m                    # 主入口 - 统一调度各后处理模块
├── gui.m                     # GUI 界面 v1（简洁版）
├── gui2.m                    # GUI 界面 v2（宽敞增强版）
├── config.json               # 配置文件（路径、工况等参数）
├── generate_config.m         # 配置文件模板生成器
├── circle_grid.mat           # 预计算的圆形网格（半径 0.375m）
│
├── fun/                      # 功能函数库
│   ├── averageAngleVarible.m         # 笛卡尔坐标 → 极坐标角度平均
│   ├── averageAngleVaribleGrid.m     # 网格插值 + 角度平均（核心算法）
│   ├── extractCustomTimeData.m       # 从 averagedata 文件提取时间序列
│   ├── interpolate_to_grid.m         # 通用网格插值函数
│   ├── plot_varible_on_line.m        # 沿轴向绘制变量分布曲线
│   ├── pressureDistort.m             # 压力畸变分析（紊流度/不均匀度）
│   ├── smooth2a.m                    # 二维均值平滑滤波（忽略 NaN）
│   ├── temperatureAngle.m            # 温度角度分析（基础版）
│   ├── temperatureAnglePlus.m        # 温度角度分析（增强版）
│   ├── testPicture.m                 # 云图绘制（插值 + 平滑 + 等值线）
│   └── mesh/
│       ├── createCircleMesh.m        # 圆形网格生成器（可配置半径和分辨率）
│       └── createMesh.m              # 矩形网格生成器
│
├── script/                   # 后处理脚本
│   ├── steadyPost.m                 # 单工况稳态后处理（串行）
│   ├── steadyPostParallel.m         # 单工况稳态后处理（并行加速）
│   ├── multiSteadyPost.m            # 多工况批量稳态后处理
│   ├── unsteadyPost.m               # 瞬态后处理
│   └── multiContourPrint.m          # 多工况云图对比输出
│
└── test/                     # 测试脚本
    ├── test.m
    ├── calulate_T.m
    └── ui.m
```

---

## 🚀 快速开始

### 1. 配置参数

首次运行会自动生成 `config.json` 模板，也可手动编辑或通过 GUI 操作：

```json
{
  "general": {
    "runMode": 3,
    "meshType": [1, 0.375, 500]
  },
  "unsteadyPost": {
    "root_path": "E:\\Desktop\\RDC\\caseRDC29\\plane1.35"
  },
  "multiSteadyPost": {
    "root_path": "E:\\Desktop\\RDC\\caseRDC27\\result",
    "cases": ["steady1", "steady11", "steady2"],
    "limits": ["min", "mid1", "max"]
  },
  "multiContourPrint": {
    "root_path": ["path1", "path2"],
    "titles": ["工况2", "工况7"]
  }
}
```

### 2. 运行方式

**命令行模式**（推荐）：
```matlab
main()          % 根据 config.json 中的 runMode 自动执行对应模块
```

**GUI 模式**：
```matlab
main_gui()      % 启动图形界面，可视化选择和配置
```

### 3. runMode 说明

| 模式 | 说明 | 并行 | 脚本 |
|------|------|------|------|
| `1` | 瞬态后处理 | ❌ | `unsteadyPost.m` |
| `2` | 多工况稳态后处理 | ✅ 4核 | `multiSteadyPost.m` |
| `3` | 多工况云图对比 | ❌ | `multiContourPrint.m` |

### 4. meshType 参数

`[类型, 半径m, 分辨率DPI]`
- 类型 `1`：圆形网格（用于管道/通道截面）
- 半径：默认 0.375m（750mm 直径管道）
- 分辨率：默认 500×500 网格点

---

## 📊 核心功能详解

### 稳态后处理 (`multiSteadyPost`)

批量处理多个工况（cases）在不同工况极限（limits）下的数据：

1. **读取截面数据**：自动识别 `planexy*` 文件，按文件名数字排序
2. **自动判断截面方向**：通过坐标方差最小值确定轴向，保留截面坐标
3. **圆形区域过滤**：根据半径 $r = \sqrt{x^2 + y^2} \leq 0.375$ 过滤有效数据点
4. **角度平均计算**：按 $5°$ 步长对截面物理量进行角度平均
5. **输出结果**：
   - `angleTable.csv` — 角度范围随轴向位置变化
   - `highTempTable.csv` — 高温区平均温度随轴向位置变化
   - `hotPointTempTable.csv` — 热点温度随轴向位置变化

### 瞬态后处理 (`unsteadyPost`)

处理随时间变化的流场数据：

1. 解析 `averagedata` 文件提取时间序列
2. 按时间步读取所有 `planexy*` 截面数据
3. 计算每个时间步的角度平均温度场
4. 生成 `resultaverage.mat` 用于后续分析

### 云图对比 (`multiContourPrint`)

将多个工况的截面云图绘制在同一张图中进行对比：
- 自动布局子图（每行3个）
- 统一色标范围（300K - 1200K）
- 支持自定义工况标题

### 压力畸变分析 (`pressureDistort`)

计算 AIP（Aerodynamic Interface Plane）面的压力畸变指标：
- **面平均紊流度** $\varepsilon$：总压脉动均方根与平均总压之比
- **高压区角度范围**：超过平均压力的角度跨度
- **压力不均匀度**：径向和周向压力分布偏差

---

## 🛠 依赖与环境

- **MATLAB R2020b+**（需要 `parfor` 支持和 `jsondecode`/`jsonencode`）
- **Parallel Computing Toolbox**（模式2并行加速时需要）
- 数据格式：CFD 导出的 CSV/TXT 截面数据文件（含 `x_coordinate`, `y_coordinate`, `z_coordinate`, `pressure`, `total_temperature` 列）

---

## 📝 数据目录规范

```
result/
├── steady1/              # 工况1
│   ├── min/              # 最小工况极限
│   │   ├── planexy1.2    # 截面数据文件（1.2m 轴向位置）
│   │   ├── planexy1.35
│   │   └── ...
│   ├── mid1/             # 中间工况极限
│   └── max/              # 最大工况极限
├── steady2/
└── ...
```

每个 `planexy*` 文件包含列：
- `x_coordinate`, `y_coordinate`, `z_coordinate` — 三维坐标
- `pressure` — 静压（Pa）
- `total_temperature` — 总温（K）

---

## 📄 License

内部研究工具，仅供项目组使用。
