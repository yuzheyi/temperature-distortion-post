# 脉冲爆震温度畸变装置 - MATLAB 工具集

> 脉冲爆震发动机（PDC）温度畸变装置的数值仿真与后处理工具集，包含热力学计算、CFD 后处理和数据可视化。

---

## 📁 项目结构

```
matlab/
├── thermal_calculate/          # 热力学验证计算
│   ├── class/                  # 类定义
│   │   ├── AirInletParameters.m      # 空气入口参数
│   │   ├── DetonationCondition.m     # 爆震工况参数
│   │   └── FuelProperties.m          # 燃油特性参数
│   ├── function/               # 功能函数
│   │   ├── air_massflow.m            # 空气质量流量计算
│   │   ├── fuel_massflow.m           # 燃油质量流量计算
│   │   ├── detonationFrequency.m     # 爆震频率计算
│   │   └── energy.m                  # 能量守恒计算
│   ├── condition_frequency.m   # 工况频率计算脚本
│   └── readme.md               # 详细说明文档
│
├── postprocessingPlus/         # CFD 后处理系统（MATLAB + R 语言）
│   ├── matlab/                 # MATLAB 数据处理
│   │   ├── main.m              # 主入口 - 统一调度各后处理模块
│   │   ├── gui.m / gui2.m     # GUI 界面
│   │   ├── config.json         # 配置文件
│   │   ├── fun/                # 功能函数库
│   │   │   ├── averageAngleVarible.m      # 角度平均分析
│   │   │   ├── averageAngleVaribleGrid.m  # 网格插值+角度平均（核心算法）
│   │   │   ├── temperatureAngle.m         # 温度角度分析
│   │   │   ├── pressureDistort.m          # 压力畸变分析
│   │   │   └── mesh/                      # 网格生成器
│   │   ├── script/             # 后处理脚本
│   │   │   ├── steadyPost.m              # 单工况稳态后处理
│   │   │   ├── steadyPostParallel.m      # 并行加速后处理
│   │   │   ├── multiSteadyPost.m         # 多工况批量后处理
│   │   │   └── unsteadyPost.m            # 瞬态后处理
│   │   └── test/               # 测试脚本
│   │
│   ├── Rlanguage/              # R 语言可视化
│   │   ├── data.r              # AIP 平均温度时间变化
│   │   ├── matlabData.r        # MATLAB 计算结果绘图
│   │   ├── mfData.r            # 入口流量统计
│   │   ├── pdc.r               # 爆震管出口参数
│   │   └── time.r              # 时间格式转换
│   │
│   └── readme.md               # 详细说明文档
│
├── averagedata/                # 平均数据存储
├── mfdata/                     # 质量流量数据
├── mfData1/                    # 质量流量数据（备选）
├── number.m                    # 爆震管数目计算脚本
├── time.csv                    # 时间数据
├── AIP面统计.txt               # AIP 面统计结果
└── readme.md                   # 本文件
```

---

## 🔧 功能模块说明

### 1. 热力学验证计算 (`thermal_calculate`)

基于能量守恒原理的热力学计算模块：

- **空气流量计算**：根据化学恰当比和实际当量比确定空气流量
- **燃油流量计算**：根据燃油热值与总加热量计算燃油流量
- **爆震管数目计算**：
  - 工程设计：根据空气最大流量和单管参数计算所需爆震管数目
  - 实验操作：已知爆震管数目和参数，确定工作频率

**使用方式**：
```matlab
% 在 thermal_calculate 目录下运行
condition_frequency
```

### 2. CFD 后处理系统 (`postprocessingPlus`)

基于 MATLAB 和 R 语言的混合后处理系统，直接通过面数据进行重建插值，具有更高的计算效率。

**MATLAB 功能**：
- 稳态/瞬态后处理
- 多工况批量处理（支持并行加速）
- 温度/压力畸变分析
- 云图对比输出

**R 语言功能**：
- 专业级可视化绘图
- 时间序列分析
- 流量统计分析

**使用方式**：
```matlab
% 命令行模式
main()          % 根据 config.json 中的 runMode 自动执行

% GUI 模式
main_gui()      % 启动图形界面
```

---

## 🚀 快速开始

### 1. 配置参数

编辑 `postprocessingPlus/matlab/config.json`：

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
    "cases": ["steady1", "steady11", "steady2"]
  }
}
```

### 2. 运行模式

| runMode | 说明 | 并行 | 脚本 |
|---------|------|------|------|
| `1` | 瞬态后处理 | ❌ | `unsteadyPost.m` |
| `2` | 多工况稳态后处理 | ✅ | `multiSteadyPost.m` |
| `3` | 多工况云图对比 | ❌ | `multiContourPrint.m` |

---

## 📊 数据说明

### 输入数据格式

- **CFD 输出**：ANSYS Fluent `.cas` / `.dat` 文件
- **时间数据**：`time.csv` 格式

### 输出数据

- `averagedata/`：平均统计数据
- `AIP面统计.txt`：AIP 面统计结果
- 各类 `.pdf` 图表文件

---

## 📝 更新日志

- **v2.0**：重构后处理系统，新增并行计算支持
- **v1.0**：初始版本，基础热力学计算

---

## 📄 许可证

本项目仅用于学术研究目的。
