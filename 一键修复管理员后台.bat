@echo off
title 一键修复管理员后台
color 0F

echo.
echo ========================================
echo        一键修复管理员后台
echo ========================================
echo.

echo [信息] 正在检查并修复管理员后台问题...
echo.

:: 检查管理员后台目录
if not exist "D:\表白墙部署\管理员后台" (
    echo [1/4] 创建管理员后台目录...
    mkdir "D:\表白墙部署\管理员后台"
    echo [成功] 管理员后台目录已创建
) else (
    echo [1/4] 管理员后台目录已存在
)

cd /d "D:\表白墙部署\管理员后台"

:: 检查index.html文件
if exist "index.html" (
    echo [2/4] index.html文件已存在
) else (
    echo [错误] index.html文件不存在，无法继续修复
    echo [提示] 请从原始部署文件中复制index.html到管理员后台目录
    pause
    exit
)

:: 创建server.js文件
echo [3/4] 创建server.js文件...
(
echo const http = require('http'); > server.js
echo const fs = require('fs'); >> server.js
echo const path = require('path'); >> server.js
echo. >> server.js
echo const PORT = 8001; >> server.js
echo const SERVER_TITLE = '表白墙管理员后台'; >> server.js
echo. >> server.js
echo const MIME_TYPES = { >> server.js
echo   '.html': 'text/html', >> server.js
echo   '.js': 'text/javascript', >> server.js
echo   '.css': 'text/css', >> server.js
echo   '.json': 'application/json', >> server.js
echo   '.png': 'image/png', >> server.js
echo   '.jpg': 'image/jpeg', >> server.js
echo   '.gif': 'image/gif', >> server.js
echo   '.svg': 'image/svg+xml', >> server.js
echo   '.wav': 'audio/wav', >> server.js
echo   '.mp4': 'video/mp4', >> server.js
echo   '.woff': 'application/font-woff', >> server.js
echo   '.ttf': 'application/font-ttf', >> server.js
echo   '.eot': 'application/vnd.ms-fontobject', >> server.js
echo   '.otf': 'application/font-otf', >> server.js
echo   '.wasm': 'application/wasm' >> server.js
echo }; >> server.js
echo. >> server.js
echo const server = http.createServer((req, res) =^> { >> server.js
echo   // 解析URL >> server.js
echo   let filePath = '.' + req.url; >> server.js
echo   if (filePath === './') { >> server.js
echo     filePath = './index.html'; >> server.js
echo   } >> server.js
echo. >> server.js
echo   // 获取文件扩展名 >> server.js
echo   const extname = String(path.extname(filePath)).toLowerCase(); >> server.js
echo   const mimeType = MIME_TYPES[extname] ^|^| 'application/octet-stream'; >> server.js
echo. >> server.js
echo   // 设置CORS头 >> server.js
echo   res.setHeader('Access-Control-Allow-Origin', '*'); >> server.js
echo   res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE'); >> server.js
echo   res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization'); >> server.js
echo. >> server.js
echo   // 读取文件 >> server.js
echo   fs.readFile(filePath, (error, content) =^> { >> server.js
echo     if (error) { >> server.js
echo       if (error.code === 'ENOENT') { >> server.js
echo         res.writeHead(404, { 'Content-Type': 'text/html' }); >> server.js
echo         res.end('^<h1^>404 Not Found^</h1^>', 'utf-8'); >> server.js
echo       } else { >> server.js
echo         res.writeHead(500); >> server.js
echo         res.end('Server Error: ' + error.code, 'utf-8'); >> server.js
echo       } >> server.js
echo     } else { >> server.js
echo       res.writeHead(200, { 'Content-Type': mimeType }); >> server.js
echo       res.end(content, 'utf-8'); >> server.js
echo     } >> server.js
echo   }); >> server.js
echo }); >> server.js
echo. >> server.js
echo server.listen(PORT, () =^> { >> server.js
echo   console.log(''); >> server.js
echo   '========================================'); >> server.js
echo   console.log('  ' + SERVER_TITLE + ' 服务器已启动'); >> server.js
echo   '========================================'); >> server.js
echo   console.log(''); >> server.js
echo   console.log('访问地址: http://localhost:' + PORT); >> server.js
echo   console.log(''); >> server.js
echo   console.log('默认登录账号: admin'); >> server.js
echo   console.log('默认登录密码: 123456'); >> server.js
echo   console.log(''); >> server.js
echo   console.log('按 Ctrl+C 停止服务器'); >> server.js
echo   console.log(''); >> server.js
echo   '========================================'); >> server.js
echo }); >> server.js
)

:: 启动服务
echo [4/4] 启动管理员后台服务...
start "表白墙管理员后台" cmd /k "node server.js"
timeout /t 2 /nobreak >nul
start http://localhost:8001

echo.
echo ========================================
echo [成功] 管理员后台已修复并启动！
echo ========================================
echo.
echo 访问地址: http://localhost:8001
echo.
echo 默认登录账号: admin
echo 默认登录密码: 123456
echo.
echo [注意] 服务窗口已在后台运行，关闭它可停止服务
echo.
pause