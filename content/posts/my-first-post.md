+++
date = '2026-03-17T12:59:40+08:00'
draft = false
title = '花1元做了一个独立博客'



作为一个纯文科背景的刑事律师，我零基础，仅靠Claudecode 和codex，用一天时间搭建了个人博客。这篇文章把我的真实过程记录下来，希望对同样想建站的非技术朋友有帮助。

## 1用 Hugo 写博客

Hugo 是一个静态网站生成器，你写 Markdown 文章，它帮你生成完整的 HTML 网页，不需要数据库，不需要服务器。

**给小白的类比：**你在 Word 里写好文章，Hugo 就是那个"排版打印机"，把内容变成漂亮的网页。

安装 Hugo、选好主题、写完文章后，运行 `hugo` 命令，会生成一个 `public` 文件夹，里面是网站的全部文件。

------

## 2用 GitHub Pages 把网站挂上线

GitHub Pages 是 GitHub 提供的免费静态网站托管服务，把 Hugo 生成的文件推送到仓库，网站就上线了。

核心步骤

新建 GitHub 仓库 → 推送 Hugo 项目 → 仓库设置里开启 GitHub Pages → 网站默认域名 `yourname.github.io`

这一步完成后，网站可以在全球大部分地区访问，但速度一般。

------

## 3接入 Cloudflare CDN 加速

Cloudflare 是全球最大的 CDN 服务商之一，免费套餐就能用。把网站接入 Cloudflare，可以让访问速度更快，同时自动提供 HTTPS 证书。

核心步骤

在 Cloudflare 注册账号 → 添加站点 → 把域名 DNS 指向 Cloudflare 提供的 NS 地址 → 开启橙色云朵（CDN代理）

**遇到问题：国内完全访问不了**
接入 Cloudflare CDN 后，我发现在中国大陆根本打不开网站。原因是 Cloudflare 的 CDN 节点在境外，会被 GFW 拦截。光换个国内域名也没用——域名只是个地址，内容还是走境外节点。

------

## 4解决方案：在阿里云买域名，把 DNS 交给 Cloudflare 管理

研究了一番之后，我发现关键不在于域名在哪买，而在于 **DNS 解析由谁来做**。

解决思路是：在阿里云注册一个国内域名，但把域名的 DNS 服务器从阿里云默认的换成 Cloudflare 提供的地址。这样，Cloudflare 就能全面管理这个域名的解析，同时我可以把 CDN 代理关掉（灰色云朵），让流量直连 GitHub Pages，绕开被墙的 CDN 节点。

DNS 是什么

DNS 就像一本"电话簿"——你输入域名，DNS 告诉浏览器对应的 IP 地址是什么。把 DNS 交给 Cloudflare 管理，相当于把"接线员"换成 Cloudflare，它能提供更多功能，比如 CDN、防火墙、HTTPS 证书等。

具体操作

1. 阿里云买好域名
2. Cloudflare 添加站点，获取两个 NS 地址（如 `xxx.ns.cloudflare.com`）
3. 在阿里云域名控制台，把 DNS 服务器替换为 Cloudflare 的 NS 地址
4. 等待生效（几分钟到 24 小时，可用 `dnschecker.org` 查询进度）
5. 在 Cloudflare DNS 设置里，把代理状态设为灰色云朵（仅 DNS，不走 CDN）

**结果：国内可以正常访问了。**
DNS 换成 Cloudflare 管理后，我可以精细控制流量走向。关掉 CDN 代理之后，访问请求直达 GitHub Pages，不再经过被墙的 Cloudflare CDN 节点，大陆用户顺利打开了网站。

------

## 5最终架构

Hugo 写文章→推送到 GitHub→GitHub Pages 托管→Cloudflare 管理 DNS→阿里云域名访问



| Hugo                     | 免费           |
| ------------------------ | -------------- |
| GitHub Pages 托管        | 免费           |
| Cloudflare DNS 管理      | 免费           |
| 阿里云域名（首年活动价） | ¥1.00          |
| **合计**                 | **¥1.00 / 年** |
