# Pulse

<p align="center">
  <img src="https://img.shields.io/badge/Go-1.21+-00ADD8?style=flat-square&logo=go" alt="Go Version">
  <img src="https://img.shields.io/badge/Astro-4.0+-FF5D01?style=flat-square&logo=astro" alt="Astro Version">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License">
</p>

<p align="center">
  <b>轻量级服务器监控系统</b><br>
  实时监控多台服务器的 CPU、内存、磁盘、网络等指标
</p>

---

## ✨ 功能特性

- 🚀 **轻量高效** - Go 语言编写，资源占用极低
- 📊 **实时监控** - SSE 推送，毫秒级数据更新
- 🌐 **多服务器** - 支持同时监控多台服务器
- 🎨 **现代 UI** - 响应式设计，支持明暗主题
- 🌍 **多语言** - 支持中文/英文切换
- 🔒 **安全认证** - 管理后台密码保护
- 📱 **跨平台** - 支持 Linux/Windows 客户端

## 📦 系统架构

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Pulse Client  │────▶│   Pulse Server  │◀────│   Web Browser   │
│   (监控代理)     │     │   (后端服务)     │     │   (前端界面)     │
└─────────────────┘     └─────────────────┘     └─────────────────┘
        ▲                        │
        │                        ▼
   收集系统指标            存储 & 推送数据
```

## 🚀 快速开始

### 1. 部署服务端

```bash
# 下载服务端
wget https://github.com/xhhcn/Pulse/raw/main/server/probe-server

# 添加执行权限
chmod +x probe-server

# 启动服务（默认端口 8080）
./probe-server
```

访问 `http://YOUR_SERVER_IP:8080` 即可看到监控面板。

### 2. 部署客户端

**Linux 一键安装：**

```bash
curl -sSL https://raw.githubusercontent.com/xhhcn/Pulse/main/client/install.sh | sudo bash -s -- \
  --id YOUR_AGENT_ID \
  --server http://YOUR_SERVER:8080
```

**Windows 一键安装（管理员 PowerShell）：**

```powershell
irm https://raw.githubusercontent.com/xhhcn/Pulse/main/client/install.ps1 -OutFile install.ps1
.\install.ps1 -AgentId "YOUR_AGENT_ID" -ServerBase "http://YOUR_SERVER:8080"
```

### 3. 添加服务器

1. 访问管理后台：`http://YOUR_SERVER:8080/admin`
2. 首次访问设置管理密码
3. 点击 "Add Service" 添加服务器，填入与客户端相同的 Agent ID
4. 客户端会自动连接并开始上报数据

## 📋 监控指标

| 指标 | 说明 |
|------|------|
| CPU | 使用率、核心数、型号 |
| 内存 | 使用率、总量、已用 |
| 磁盘 | 使用率、总量、已用 |
| 网络 | 上传/下载速率、总流量 |
| 系统 | 操作系统、运行时间、IP 地址 |

## ⚙️ 配置

### 服务端环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `PORT` | `8080` | 服务端口 |

### 客户端环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `AGENT_ID` | - | 代理 ID（必填） |
| `AGENT_NAME` | `AGENT_ID` | 显示名称 |
| `SERVER_BASE` | `http://localhost:8080` | 服务端地址 |
| `CLIENT_PORT` | `9090` | 客户端监听端口 |

## 🛠️ 开发

### 项目结构

```
tz/
├── server/           # 服务端
│   ├── main.go       # 主程序
│   ├── store.go      # 数据存储
│   └── web/          # 前端代码 (Astro)
│       └── src/
│           ├── pages/
│           └── components/
├── client/           # 客户端
│   ├── main.go       # 主程序
│   ├── install.sh    # Linux 安装脚本
│   └── install.ps1   # Windows 安装脚本
└── README.md
```

### 构建

```bash
# 构建服务端
cd server
go build -o probe-server .

# 构建客户端 (Linux)
cd client
GOOS=linux GOARCH=amd64 go build -o probe-client .

# 构建客户端 (Windows)
GOOS=windows GOARCH=amd64 go build -o probe-client.exe .
```

### 前端开发

```bash
cd server/web
npm install
npm run dev    # 开发模式
npm run build  # 构建生产版本
```

## 📄 License

MIT License

## 🙏 致谢

- [Go](https://golang.org/) - 后端语言
- [Astro](https://astro.build/) - 前端框架
- [Tailwind CSS](https://tailwindcss.com/) - CSS 框架
- [Chart.js](https://www.chartjs.org/) - 图表库

