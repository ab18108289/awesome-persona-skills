# 投稿指南

感谢你为本目录补充条目。这个仓库是 **GitHub 原生目录库**，不是热榜，也不是泛 AI 收藏夹。投稿前请先对照下面的口径。

如果你只是想推荐一个项目、但暂时不打算改文件，请直接使用 GitHub 的 `推荐新条目` Issue 模板。

如果你已经准备好修改 `data/skills.json` 并重建 `README.md`，再发 Pull Request。

## 收录要求

- **必须**是 GitHub 上公开可访问的仓库链接。
- **优先**收录标准 `Skill / Agent Skill / .skill` 项目。
- **允许**少量高质量的人格化 AI repo 进入目录，但必须明确具备人物感、角色感、人格视角或神秘人格体验。
- **主轴**以国内中文圈项目为主，海外知名人物类项目只作为补充。
- **排除**纯工具链、纯 workflow、纯工程脚手架、纯提示词杂烩等无清晰人设叙事的仓库。
- 描述应基于仓库自述或可核验信息，避免营销化、夸大化描述。

## 数据字段

在 `data/skills.json` 的数组中追加对象，字段需齐全：

| 字段 | 说明 |
|------|------|
| `name` | 条目显示名称，建议短且可读 |
| `category` | 一级分类，必须是下列 8 个字符串之一 |
| `type` | 形态说明，如 `真实人物 Skill`、`角色人格 Skill`、`人格化 AI Repo` |
| `description` | 一两句话说明它是谁 / 它适合做什么 |
| `repo_url` | GitHub 仓库 HTTPS 地址，勿重复 |
| `tags` | 字符串数组，建议 2-5 个 |
| `stars` | 数字或 `null` |
| `status` | 允许值：`active`、`watchlist`、`seed` |
| `entry_kind` | 允许值：`skill`、`persona_repo`、`watchlist` |
| `featured` | `true` 或 `false`，仅少量代表条目标 `true` |

## `entry_kind` 怎么选

- `skill`
  适用于标准 Skill / Agent Skill 仓库，或以 SKILL.md 形态交付的项目。
- `persona_repo`
  适用于不是标准 Skill，但明显是人格化 AI 项目、角色模拟项目或强人设 repo。
- `watchlist`
  适用于题材贴题，但形态、质量或长期维护状态还需要观察的项目。

## 允许的 `category`

1. `热门网红 / 博主 Skill`
2. `商业人物 / 创业者 Skill`
3. `教育 / 职业导师 Skill`
4. `情感人物 / 关系人格 Skill`
5. `职场角色人格 Skill`
6. `玄学人物 / 神秘人格 Skill`
7. `经典人格 / 自我镜像 Skill`
8. `新收录 / 待观察`

## 投稿检查清单

- [ ] 仓库公开可访问
- [ ] 明显具备人物 / 角色 / 人格 / 玄学娱乐属性
- [ ] 描述客观，不像广告文案
- [ ] `repo_url` 未和现有条目重复
- [ ] `name` 不与现有条目重名
- [ ] 已填写 `entry_kind` 和 `featured`

## 提交前命令

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\generate-readme.ps1
```

两个命令都通过后再发起 PR。

如果这次只是在推荐项目，不需要先改文件；把仓库链接、建议分类和贴题理由写进 Issue 即可。
