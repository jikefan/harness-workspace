```text
╔══════════════════════════════════════════════════════════════════════╗
║                                                                      ║
║   ██╗  ██╗ █████╗ ██████╗ ███╗   ██╗███████╗███████╗███████╗       ║
║   ██║  ██║██╔══██╗██╔══██╗████╗  ██║██╔════╝██╔════╝██╔════╝       ║
║   ███████║███████║██████╔╝██╔██╗ ██║█████╗  ███████╗███████╗       ║
║   ██╔══██║██╔══██║██╔══██╗██║╚██╗██║██╔══╝  ╚════██║╚════██║       ║
║   ██║  ██║██║  ██║██║  ██║██║ ╚████║███████╗███████║███████║       ║
║   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝       ║
║                                                                      ║
║                    W O R K S P A C E   F O R                       ║
║              A G E N T I C   E N G I N E E R I N G                 ║
║                                                                      ║
╚══════════════════════════════════════════════════════════════════════╝
```

# Harness Workspace

> 面向 AI Coding Agent 的工程化作业台：把上下文、规则、任务、工具与证据沉淀为可复用的本地操作系统。

Prefer English? Read the [English version](README.md).

`Harness Workspace` 不是某一个业务项目的源码仓库，而是一套用于管理多项目、多仓库、多人机协作开发流程的 **Agentic Engineering Harness**。它将“临时对话式开发”升级为“可追踪、可审计、可迁移、可复用”的工程体系，让 AI Agent 不只是执行命令，而是在清晰边界、项目画像、质量门禁和安全策略下可靠地完成工作。

## 愿景

在复杂软件交付中，真正稀缺的不是单次代码生成能力，而是持续稳定的工程上下文：

- 项目的规则在哪里？
- 哪些目录可以提交，哪些只能本地保留？
- Agent 应该先读什么、跑什么、验证什么？
- 多仓库任务如何拆分、记录、归档和复盘？
- 生成的日志、截图、报告应该放在哪里？
- 私有客户信息如何避免误提交？

本仓库试图回答这些问题。它提供一个项目无关的基础底座，让每一个真实项目都可以通过 profile 接入，同时让公开仓库只保留通用规则、匿名样例、模板和安全工具。

## 核心能力

- **Agent 规则中枢**：通过 `AGENTS.md` 定义全局行为契约，让 Agent 在统一边界内行动。
- **项目画像 Profile**：用 `profiles/<project>/` 描述项目规则、仓库清单、环境信息和工具入口。
- **任务工作区 Lifecycle**：用 `projects/<project>/active|archived|scratch/` 管理任务从启动到归档的全过程。
- **工具统一入口**：通过 `tools/harness` 聚合审计、任务状态、仓库状态等常用命令。
- **安全开源策略**：默认忽略真实项目资料、工作副本、生成产物、缓存状态和常见密钥文件。
- **模板化扩展**：通过 `templates/` 快速复制 profile、task、repo-local harness 的标准结构。
- **证据优先交付**：鼓励把检查脚本、报告、截图和决策记录沉淀到约定位置，减少口头确认。

## 目录结构

```text
AGENTS.md                 # Agent 根规则：行为边界、工作协议、安全约束
docs/                     # Harness 设计文档与操作指南
profiles/                 # 项目画像；公开仓库仅保留匿名示例
projects/                 # 项目任务注册表与工作区；真实项目默认忽略
templates/                # profile、task、repo harness 的可复用模板
tools/                    # 可执行工具与统一入口
artifacts/                # 生成报告、日志、截图、导出文件；默认忽略
tmp/                      # 一次性草稿与临时文件；默认忽略
```

## 快速开始

```bash
# 体检当前 harness 结构
tools/harness audit

# 查看匿名示例项目的任务注册表
tools/harness task-status example-product

# 查看匿名示例项目的仓库状态
tools/harness repo-status example-product
```

如果你要接入一个新项目，建议从模板开始：

```bash
cp -R templates/profile profiles/<project-id>
```

然后补充：

- `profiles/<project-id>/AGENTS.md`：项目级 Agent 规则
- `profiles/<project-id>/profile.yml`：项目基本信息与运行约定
- `profiles/<project-id>/repos.yml`：仓库清单
- `profiles/<project-id>/environments.yml`：环境说明，只写入口与规则，不写密钥
- `profiles/<project-id>/tools.yml`：项目专用工具索引

## 工作流模型

### 1. 先有规则，再有执行

Agent 在进入真实项目之前，应先读取根 `AGENTS.md` 与对应项目 profile。规则不是装饰，而是保护工程边界、减少误操作、确保可复盘的第一道防线。

### 2. 先建任务工作区，再动业务代码

真实业务仓库不应直接散落在根目录。推荐结构：

```text
projects/<project>/active/<task-id>/<repo-clone>
```

任务完成后移动到：

```text
projects/<project>/archived/YYYY-MM/<task-id>
```

短期实验放入：

```text
projects/<project>/scratch/<experiment>
```

### 3. 先执行检查，再声明完成

优先使用仓库内的检查脚本，例如：

```bash
scripts/agent/check.sh
```

如果没有项目级检查脚本，再使用 profile 中记录的约定命令。交付时应报告实际执行过的验证，而不是只给结论。

## 开源安全设计

本仓库被设计为可公开发布，但前提是遵守 `.gitignore` 中的安全边界。

默认不会提交：

- 真实项目 profile
- 真实任务注册表
- 克隆出来的业务源码工作副本
- 生成报告、截图、日志、CSV、数据库 dump
- 本地缓存、运行时状态、`.omx/`
- `.env`、证书、私钥、token、password 等常见敏感文件

公开仓库应只包含：

- 通用文档
- 匿名示例
- 可复用模板
- 安全的工具入口
- 不含客户信息和内部路径的规范说明

## 设计原则

- **边界清晰**：业务代码、任务产物、临时文件、长期文档各归其位。
- **默认安全**：敏感内容默认本地保留，公开内容必须可审计。
- **工具优先**：能用脚本验证的规则，不只写在文档里。
- **可迁移**：profile 让同一套 harness 可以服务多个项目。
- **可复盘**：任务、发现、进度和检查结果尽量结构化沉淀。
- **可协作**：人类、AI Agent、CI 与运维工具共享同一套工作约定。

## 适用场景

- 多仓库产品研发
- AI Coding Agent 长期协作
- 项目规则和工具沉淀
- 任务型 worktree / clone 管理
- 私有项目与公开模板分离
- 代码审查、发布检查、运维报告的标准化

## 后续路线

- 增强 `tools/harness` 的结构化检查能力
- 增加 profile 初始化脚手架
- 增加任务归档与报告生成命令
- 增加 repo-local `scripts/agent/check.sh` 的最佳实践模板
- 增加更严格的公开仓库敏感信息扫描

## License

本项目采用 [MIT License](LICENSE) 开源。
